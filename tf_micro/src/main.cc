// 
// Running MNIST classification on Zynq RPU
// 
#include <iostream>

#include "tensorflow/lite/micro/all_ops_resolver.h"
#include "tensorflow/lite/micro/micro_error_reporter.h"
#include "tensorflow/lite/micro/micro_interpreter.h"
#include "tensorflow/lite/schema/schema_generated.h"
#include "tensorflow/lite/version.h"

#include "model_quant.h"	// Exported TFLite micro model
#include "data.h"			// Input data ("7")


const int tensor_arena_size = 40 * 1024;
uint8_t tensor_arena[tensor_arena_size];


int main(void)
{
	std::cout << "..... TensorFlow Lite for Micro Controllers ..." << std::endl;
	std::cout << "TF version: " << TFLITE_VERSION_STRING << std::endl;

	tflite::MicroInterpreter* interpreter = nullptr;

	static tflite::MicroErrorReporter micro_error_reporter;
	tflite::ErrorReporter* error_reporter = &micro_error_reporter;

	// Map the model into a usable data structure. This doesn't involve any
	// copying or parsing, it's a very lightweight operation.
	const tflite::Model* model = tflite::GetModel(model_quant_tflite);
	if (model->version() != TFLITE_SCHEMA_VERSION) {
		TF_LITE_REPORT_ERROR(error_reporter,
			"Model provided is schema version %d not equal "
			"to supported version %d.",
			model->version(), TFLITE_SCHEMA_VERSION);
		return -1;
	}

	// This pulls in all the operation implementations we need.
	static tflite::AllOpsResolver resolver;

	// Build an interpreter to run the model with.
	static tflite::MicroInterpreter static_interpreter(
		model, resolver, tensor_arena, tensor_arena_size, error_reporter);
	interpreter = &static_interpreter;

	// Allocate memory from the tensor_arena for the model's tensors.
	TfLiteStatus allocate_status = interpreter->AllocateTensors();
	if (allocate_status != kTfLiteOk) {
		TF_LITE_REPORT_ERROR(error_reporter, "AllocateTensors() failed");
		return -1;
	}

	// Obtain pointers to the model's input and output tensors.
	TfLiteTensor* input = interpreter->input(0);
	TfLiteTensor* output = interpreter->output(0);

	//
	if( (input == nullptr) || (output == nullptr) ){
		std::cerr << "[ERROR] Input/Output tensor is null..." << std::endl;
	}	
	std::cout << "[INFO] Input size: " << 
		input->dims->data[0] << " x " << input->dims->data[1] << " x " <<
		input->dims->data[2] << " x " << input->dims->data[3] << std::endl;

	std::cout << "[INFO] Quantization param:" << std::endl <<
		"    type:       " << input->quantization.type << std::endl <<
		"    scale:      " << input->params.scale << std::endl <<
		"    zero point: " << input->params.zero_point << std::endl;

	// Input is INT8 (->type = 9)
	for(int i = 0; i < 28*28; i++){
		input->data.int8[i] = 
			static_cast<int8_t>( digit_7[i]/255.f/input->params.scale - input->params.zero_point);
	}

	// Run inference, and report any error
	TfLiteStatus invoke_status = interpreter->Invoke();
	if (invoke_status != kTfLiteOk) {
		std::cerr << "Invoke failed on x_val" << std::endl;
		TF_LITE_REPORT_ERROR(error_reporter, "Invoke failed\n");
		return -1;
	}

	// Log the output score
	int idx = 0;
	int8_t score = output->data.int8[0];
	for (int i = 0; i < 10; i++){
		std::cout << "Score[" << i << "]: " << 
			static_cast<int>(output->data.int8[i]) << std::endl;

		if(output->data.int8[i] > score){
			idx = i;
			score = output->data.int8[i];
		}
	}

	// Display the result
	std::cout << "Output: " << idx << std::endl;

	std::cout << "..... DONE ....." << std::endl;

	return 0;
}

/*
 * Empty C++ Application
 */

#include <iostream>

#include "tensorflow/lite/experimental/micro/kernels/all_ops_resolver.h"
#include "tensorflow/lite/experimental/micro/micro_error_reporter.h"
#include "tensorflow/lite/experimental/micro/micro_interpreter.h"
#include "tensorflow/lite/schema/schema_generated.h"
#include "tensorflow/lite/version.h"

#include "model.h"
#include "data.h"


const int tensor_arena_size = 200 * 1024;
uint8_t tensor_arena[tensor_arena_size];


int main(void)
{
	DebugLog("..... TensorFlow Lite for Micro Controllers .....\n");

	DebugLog("TF version: ");
	DebugLog(TFLITE_VERSION_STRING);
	DebugLog("\n");

	tflite::MicroErrorReporter micro_error_reporter;
	tflite::ErrorReporter* error_reporter = &micro_error_reporter;

	const tflite::Model* model = tflite::GetModel(g_person_detect_model_data);
	if (model->version() != TFLITE_SCHEMA_VERSION) {
		error_reporter->Report(
				"Model provided is schema version %d not equal "
				"to supported version %d.\n",
				model->version(), TFLITE_SCHEMA_VERSION);
	}

	// This pulls in all the operation implementations we need.
	tflite::ops::micro::AllOpsResolver resolver;

	tflite::SimpleTensorAllocator tensor_allocator(tensor_arena, tensor_arena_size);

	// Build an interpreter to run the model with.
	tflite::MicroInterpreter interpreter(model, resolver,
			&tensor_allocator, error_reporter);

	// Get information about the memory area to use for the model's input.
	TfLiteTensor* input = interpreter.input(0);

	// Input is FP32
	for(int i = 0; i < 28*28; i++){
		input->data.f[i] = digit_7[i]/255.0;
	}

	// Run the model on this input and make sure it succeeds.
	TfLiteStatus invoke_status = interpreter.Invoke();
	if (invoke_status != kTfLiteOk) {
		error_reporter->Report("Invoke failed\n");
	}

	TfLiteTensor* output = interpreter.output(0);

	// Log the output score
	int idx = 0;
	float score = output->data.f[0];

	for (int i = 0; i < 10; i++){
		std::cout << "Score: " << output->data.f[i] << std::endl;

		if(output->data.f[i] > score){
			idx = i;
			score = output->data.f[i];
		}
	}

	// Display the result
	std::cout << "Output: " << idx << std::endl;

	return 0;
}

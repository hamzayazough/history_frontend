import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:history_timeline/core/constants/app_constants.dart';
import 'package:history_timeline/core/theme/app_theme.dart';

class CreateEventView extends ConsumerStatefulWidget {
  final String? regionId;

  const CreateEventView({
    super.key,
    this.regionId,
  });

  @override
  ConsumerState<CreateEventView> createState() => _CreateEventViewState();
}

class _CreateEventViewState extends ConsumerState<CreateEventView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _sourceUrlController = TextEditingController();

  String? _selectedRegionId;
  XFile? _selectedImage;
  bool _isLoading = false;

  final List<RegionOption> _regions = [
    RegionOption(id: '1', name: 'Europe'),
    RegionOption(id: '2', name: 'Asia'),
    RegionOption(id: '3', name: 'Africa'),
    RegionOption(id: '4', name: 'North America'),
    RegionOption(id: '5', name: 'South America'),
    RegionOption(id: '6', name: 'Oceania'),
  ];

  @override
  void initState() {
    super.initState();
    _selectedRegionId = widget.regionId;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _selectStartDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        _startDateController.text = '${date.year}';
      });
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        _endDateController.text = '${date.year}';
      });
    }
  }

  Future<void> _createEvent() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedRegionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a region')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO: Implement GraphQL mutation to create event
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event created successfully!')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating event: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _createEvent,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Create'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusLarge),
                    border: Border.all(color: AppColors.grey300),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusLarge),
                          child: Image.network(
                            _selectedImage!.path,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error),
                          ),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate,
                              size: 48,
                              color: AppColors.grey400,
                            ),
                            SizedBox(height: AppDimensions.spacing8),
                            Text(
                              'Add Image (Optional)',
                              style: TextStyle(color: AppColors.grey600),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacing24),

              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Event Title',
                  hintText: 'Enter the name of the historical event',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an event title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.spacing16),

              // Region Dropdown
              DropdownButtonFormField<String>(
                value: _selectedRegionId,
                decoration: const InputDecoration(
                  labelText: 'Region',
                ),
                items: _regions.map((region) {
                  return DropdownMenuItem(
                    value: region.id,
                    child: Text(region.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedRegionId = value);
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a region';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.spacing16),

              // Date Fields
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _startDateController,
                      decoration: const InputDecoration(
                        labelText: 'Start Year',
                        hintText: 'e.g., 476',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: _selectStartDate,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please select a start year';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacing16),
                  Expanded(
                    child: TextFormField(
                      controller: _endDateController,
                      decoration: const InputDecoration(
                        labelText: 'End Year (Optional)',
                        hintText: 'e.g., 480',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: _selectEndDate,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacing16),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Provide detailed information about the event...',
                  alignLabelWithHint: true,
                ),
                maxLines: 8,
                maxLength: AppConstants.maxDescriptionLength,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value.trim().length < 50) {
                    return 'Description should be at least 50 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.spacing16),

              // Source URL Field
              TextFormField(
                controller: _sourceUrlController,
                decoration: const InputDecoration(
                  labelText: 'Source URL (Optional)',
                  hintText: 'https://example.com/source',
                  prefixIcon: Icon(Icons.link),
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: AppDimensions.spacing32),

              // Guidelines
              Container(
                padding: const EdgeInsets.all(AppDimensions.spacing16),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusMedium),
                  border: Border.all(color: AppColors.info.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info,
                          color: AppColors.info,
                          size: AppDimensions.iconSmall,
                        ),
                        const SizedBox(width: AppDimensions.spacing8),
                        Text(
                          'Content Guidelines',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.info,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spacing8),
                    const Text(
                      '• Provide accurate historical information\n'
                      '• Include reliable sources when possible\n'
                      '• Be respectful and objective\n'
                      '• Avoid modern political bias',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _sourceUrlController.dispose();
    super.dispose();
  }
}

class RegionOption {
  final String id;
  final String name;

  RegionOption({required this.id, required this.name});
}

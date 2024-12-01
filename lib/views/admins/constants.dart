import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color.fromARGB(31, 168, 168, 168);
const bgColor = Color(0xFF212332);
const defaultTextColor = Color.fromARGB(255, 77, 67, 67);

const defaultPadding = 16.0;

TextFormField textFormFieldEmail(emailController) {
  return TextFormField(
    controller: emailController,
    decoration: InputDecoration(
      labelText: "Email",
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xFFD1E1FF), // Retained color
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xFFD1E1FF), // Retained color
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xFFD1E1FF), // Retained color
          width: 1.5,
        ),
      ),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Required field.';
      }
      if (!EmailValidator.validate(value)) {
        return "Provide a valid email address";
      }
      return null;
    },
  );
}

TextFormField textFormFieldName(nameController, labelText, isEnabled) {
  return TextFormField(
    enabled: isEnabled,
    controller: nameController,
    decoration: InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xFFD1E1FF), // Retained color
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xFFD1E1FF), // Retained color
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xFFD1E1FF), // Retained color
          width: 1.5,
        ),
      ),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Required field.';
      }
      return null;
    },
  );
}

TextFormField textFormFieldPhoneNumber(phoneNumber) {
  return TextFormField(
    controller: phoneNumber,
    decoration: InputDecoration(
      labelText: "Phone number",
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xFFD1E1FF), // Retained color
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xFFD1E1FF), // Retained color
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xFFD1E1FF), // Retained color
          width: 1.5,
        ),
      ),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Required field.';
      }
      return null;
    },
    // onSaved: (value) => _password = value ?? '',
  );
}

TextFormField textFormFieldPassword(password) {
  return TextFormField(
    controller: password,
    decoration: InputDecoration(
      labelText: "Password",
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xFFD1E1FF), // Retained color
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xFFD1E1FF), // Retained color
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xFFD1E1FF), // Retained color
          width: 1.5,
        ),
      ),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Required field.';
      }
      if (value.length <= 7) {
        return "Password should at least 8 characters.";
      }
      return null;
    },
    // onSaved: (value) => _password = value ?? '',
  );
}

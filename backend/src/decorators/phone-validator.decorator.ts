import { registerDecorator, ValidationOptions } from 'class-validator';
import { PhoneNumberUtil } from 'google-libphonenumber';

export function IsValidPhoneNumber(validationOptions?: ValidationOptions) {
  return (object: any, propertyName: string) => {
    registerDecorator({
      name: 'isValidPhoneNumber',
      target: object.constructor,
      propertyName: propertyName,
      constraints: [],
      options: validationOptions,
      validator: {
        validate(value: any) {
          // Immediately return false if the number starts with '+'
          if (typeof value === 'string' && value.startsWith('+')) {
            return false;
          }

          if (value) {
            try {
              const phoneUtil = PhoneNumberUtil.getInstance();
              const phoneNumber = phoneUtil.parseAndKeepRawInput(value, 'KE');
              return phoneUtil.isValidNumber(phoneNumber);
            } catch (error) {
              // If parsing fails, consider the number invalid
              return false;
            }
          }
          // Consider empty values as valid
          return true;
        },
        defaultMessage() {
          return 'Phone number is not valid. Ensure it is a valid Kenyan number without the "+" prefix.';
        },
      },
    });
  };
}

export class SendOtpRequestDto {
  phone!: string;
}

export class VerifyOtpRequestDto {
  phone!: string;
  otp!: string;
}

export class RefreshTokenRequestDto {
  refresh_token!: string;
}

export class SelectRoleRequestDto {
  role!: 'CUSTOMER' | 'PROFESSIONAL';
}

export class AuthResponseDto {
  access_token!: string;
  refresh_token!: string;
  user!: {
    id: string;
    phone: string;
    first_name?: string | null;
    last_name?: string | null;
    photo_url?: string | null;
    role: string;
    role_selected: boolean;
    is_active: boolean;
  };
  is_new_user!: boolean;
}
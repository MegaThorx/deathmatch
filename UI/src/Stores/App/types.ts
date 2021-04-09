export const APP_SET_BLURRED = 'APP_SET_BLURRED';

export interface AppState {
	blurred: boolean
}

interface AppSetBlurredAction {
  type: typeof APP_SET_BLURRED,
  payload: boolean
}

export type AppActionTypes = AppSetBlurredAction

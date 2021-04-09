import { AppActionTypes, APP_SET_BLURRED } from "./types";

export function AppSetBlurred(blurred: boolean): AppActionTypes {
	return {
    	type: APP_SET_BLURRED,
    	payload: blurred
	}
}

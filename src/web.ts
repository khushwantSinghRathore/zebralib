import { WebPlugin } from '@capacitor/core';

import type { ZebraLibPlugin } from './definitions';

export class ZebraLibWeb extends WebPlugin implements ZebraLibPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}

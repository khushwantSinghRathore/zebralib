import { registerPlugin } from '@capacitor/core';

import type { ZebraLibPlugin } from './definitions';

const ZebraLib = registerPlugin<ZebraLibPlugin>('ZebraLib', {
  web: () => import('./web').then(m => new m.ZebraLibWeb()),
});

export * from './definitions';
export { ZebraLib };

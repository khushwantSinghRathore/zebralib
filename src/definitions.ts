export interface ZebraLibPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}

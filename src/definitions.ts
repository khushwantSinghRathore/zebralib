export interface ZebraLibPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
  connectPrinter(options: {value: string}): Promise<any>;
  printText(options: { text: string }): Promise<any>;
  printPDF(options: { base64: string }): Promise<any>;
}

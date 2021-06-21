# zebralib

zebra printer capacitor plugin library

## Install

```bash
npm install zebralib
npx cap sync
```

## API

<docgen-index>

* [`echo(...)`](#echo)
* [`connectPrinter(...)`](#connectprinter)
* [`printText(...)`](#printtext)
* [`printPDF(...)`](#printpdf)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### echo(...)

```typescript
echo(options: { value: string; }) => Promise<{ value: string; }>
```

| Param         | Type                            |
| ------------- | ------------------------------- |
| **`options`** | <code>{ value: string; }</code> |

**Returns:** <code>Promise&lt;{ value: string; }&gt;</code>

--------------------


### connectPrinter(...)

```typescript
connectPrinter(options: { value: string; }) => Promise<any>
```

| Param         | Type                            |
| ------------- | ------------------------------- |
| **`options`** | <code>{ value: string; }</code> |

**Returns:** <code>Promise&lt;any&gt;</code>

--------------------


### printText(...)

```typescript
printText(options: { text: string; }) => Promise<any>
```

| Param         | Type                           |
| ------------- | ------------------------------ |
| **`options`** | <code>{ text: string; }</code> |

**Returns:** <code>Promise&lt;any&gt;</code>

--------------------


### printPDF(...)

```typescript
printPDF(options: { base64: string; }) => Promise<any>
```

| Param         | Type                             |
| ------------- | -------------------------------- |
| **`options`** | <code>{ base64: string; }</code> |

**Returns:** <code>Promise&lt;any&gt;</code>

--------------------

</docgen-api>

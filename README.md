# zebra-capacitor

zebra printer capacitor plugin library

## Install

```bash
npm install @dolosplus/zebra-capacitor
npx cap sync
```

## API

<docgen-index>

* [`connectPrinter(...)`](#connectprinter)
* [`printText(...)`](#printtext)
* [`printPDF(...)`](#printpdf)
* [`addListener(...)`](#addlistener)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### connectPrinter(...)

```typescript
connectPrinter(options: { config: string; }) => Promise<any>
```

| Param         | Type                             |
| ------------- | -------------------------------- |
| **`options`** | <code>{ config: string; }</code> |

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


### addListener(...)

```typescript
addListener(eventName: 'printerStatusChange', listenerFunc: StateChangeListener) => Promise<PluginListenerHandle> & PluginListenerHandle
```

| Param              | Type                                          |
| ------------------ | --------------------------------------------- |
| **`eventName`**    | <code>"printerStatusChange"</code>            |
| **`listenerFunc`** | <code>(state: ConnectState) =&gt; void</code> |

**Returns:** <code>Promise&lt;<a href="#pluginlistenerhandle">PluginListenerHandle</a>&gt; & <a href="#pluginlistenerhandle">PluginListenerHandle</a></code>

--------------------


### Interfaces


#### PluginListenerHandle

| Prop         | Type                                      |
| ------------ | ----------------------------------------- |
| **`remove`** | <code>() =&gt; Promise&lt;void&gt;</code> |

</docgen-api>

https://github.com/Dawju9/BrainFck-Runner.git

Ten kod przetwarza wejściowy ciąg tekstowy, który zawiera pary klucz-wartość, oddzielone dwukropkami i zakończone nową linią. Funkcja przekształca te pary w tabelę (słownik) Lua, konwertując wartości na odpowiednie typy (liczby, wartości logiczne, `nil`). Możemy go użyć do dynamicznej konfiguracji lub ustawień dla `BrainfuckRunner`.

Oto co dokładnie robi każda część tego kodu:

	1. **Sprawdzanie typu wejściowego**:
	```lua
	assert(type(Input) == "string", "Argument 1 (Input) must be a string")
	```
	Funkcja sprawdza, czy `Input` jest ciągiem tekstowym. Jeśli nie, zgłasza błąd.

		2. **Inicjalizacja wyjściowej tabeli**:
		```lua
	Output = type(Output) == "table" and Output or {}
	```
	Funkcja sprawdza, czy `Output` jest tabelą. Jeśli nie, tworzy nową pustą tabelę.

		3. **Przetwarzanie par klucz-wartość**:
		```lua
	for Key, Value in string.gmatch(Input, "%s*(.-)%s*:%s*(.-)%s*\n") do
		```
		Funkcja używa `string.gmatch` do znajdowania wszystkich par klucz-wartość w `Input`. Wzorzec `%s*(.-)%s*:%s*(.-)%s*\n`:
			- `%s*` - opcjonalne białe znaki
			- `(.-)` - minimalnie dopasowanie do dowolnych znaków (klucz lub wartość)
				- `:` - dwukropek oddzielający klucz od wartości
				- `\n` - nowa linia kończąca parę

				4. **Konwersja wartości na odpowiednie typy**:
					```lua
				if string.lower(Value) == "nil" or string.lower(Value) == "null" or string.lower(Value) == "none" or string.lower(Value) == "nothing" or string.lower(Value) == "undefined" then
					Output[Key] = nil
				elseif string.lower(Value) == "true" then
					Output[Key] = true
				elseif string.lower(Value) == "false" then
					Output[Key] = false
				elseif tonumber(Value) then
					Output[Key] = tonumber(Value)
				else
					Output[Key] = Value
				end
				```
				Funkcja konwertuje wartość na odpowiedni typ:
					- `nil`, `null`, `none`, `nothing`, `undefined` są konwertowane na `nil`
				- `true` jest konwertowane na `true`
				- `false` jest konwertowane na `false`
				- jeśli wartość można zamienić na liczbę, jest konwertowana na liczbę
				- w przeciwnym razie pozostaje ciągiem tekstowym

				5. **Zwracanie wyniku**:
					```lua
				return Output
				```

				Przykład użycia tej funkcji do konfiguracji `BrainfuckRunner`:

					```lua
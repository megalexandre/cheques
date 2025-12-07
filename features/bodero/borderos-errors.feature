# language: pt

Funcionalidade: Borderô
  
  Cenário: Calcular um borderô com um data de vencimento inválida no cheque
    Quando eu enviar um POST para "/borderos/preview" com o JSON:
      """
      {
        "exchange_date": "2025-11-27",
        "monthly_interest": 2.5,
        "cheques": 
        [
          {
              "value": "2026-01-13",
              "due_date": "2026-00-13",
              "processing_days": 2
          }
        ]
      }
      """
    Então a resposta deve ser 400
    E a resposta JSON deve conter:
    """
    {
      "errors": [
        "Cheque 1: Due date can't be blank", 
        "Cheque 1: Due date is not a valid date"
      ]
    }
    """
  
  Cenário: Calcular um borderô com uma data de troca invalida
    Quando eu enviar um POST para "/borderos/preview" com o JSON:
      """
      {
        "exchange_date": "2025-13-27",
        "monthly_interest": 2.5,
        "cheques": 
        [
          {
              "value": 5000.00,
              "due_date": "2026-01-13",
              "processing_days": 2
          }
        ]
      }
      """
    Então a resposta deve ser 400
    E a resposta JSON deve conter:
    """
    {
      "errors": [
        "Exchange date can't be blank",
        "Exchange date is not a valid date"
      ]
    }
    """

  Cenário: Calcular um borderô com uma taxa de juros inválida
    Quando eu enviar um POST para "/borderos/preview" com o JSON:
      """
      {
        "exchange_date": "2025-11-27",
        "monthly_interest": 0,
        "cheques": 
        [
          {
              "value": 5000.00,
              "due_date": "2026-01-13",
              "processing_days": 2
          }
        ]
      }
      """
    Então a resposta deve ser 400
    E a resposta JSON deve conter:
    """
    {
      "errors": [
        "Monthly interest must be greater than 0"
      ]
    }
    """

  Cenário: Calcular um borderô cheque sem valor
    Quando eu enviar um POST para "/borderos/preview" com o JSON:
      """
      {
        "exchange_date": "2025-11-27",
        "monthly_interest": 2.5,
        "cheques": 
        [
          {
              "value": 0,
              "due_date": "2026-01-13",
              "processing_days": 2
          }
        ]
      }
      """
    Então a resposta deve ser 400
    E a resposta JSON deve conter:
    """
    {
      "errors": [
        "Cheque 1: Value must be greater than 0"
      ]
    }
    """

  Cenário: Calcular um borderô com dias em espera negativo
    Quando eu enviar um POST para "/borderos/preview" com o JSON:
      """
      {
        "exchange_date": "2025-11-27",
        "monthly_interest": 2.5,
        "cheques": 
        [
          {
              "value": 5000.00,
              "due_date": "2026-01-13",
              "processing_days": -1
          }
        ]
      }
      """
    Então a resposta deve ser 400
    E a resposta JSON deve conter:
    """
    {
      "errors": [
        "Cheque 1: Processing days must be greater than or equal to 0"
      ]
    }
    """

  Cenário: Calcular um borderô sem o campo data da troca
    Quando eu enviar um POST para "/borderos/preview" com o JSON:
      """
      {
        "monthly_interest": 2.5,
        "cheques": 
        [
          {
            "value": 5000.00,
            "due_date": "2026-01-13",
            "processing_days": 2
          }
        ]
      }
      """
      Então a resposta deve ser 400
      E a resposta JSON deve conter:
      """
      {
        "errors": [
          "Exchange date can't be blank"
        ]
      }
      """


  Cenário: Calcular um borderô sem o campo juros mensais

    Quando eu enviar um POST para "/borderos/preview" com o JSON:
    """
    {
      "exchange_date": "2025-11-27",
      "cheques": 
      [
        {
          "value": 5000.00,
          "due_date": "2026-01-13",
          "processing_days": 2
        }
      ]
    }
    """
    Então a resposta deve ser 400
    E a resposta JSON deve conter:
    """
    {
      "errors": [
        "Monthly interest can't be blank",
        "Monthly interest is not a number"
      ]
    }
    """


  Cenário: Calcular um borderô sem o campo cheques

    Quando eu enviar um POST para "/borderos/preview" com o JSON:
    """
    {
      "exchange_date": "2025-11-27",
      "monthly_interest": 2.5
    }
    """
    Então a resposta deve ser 400
    E a resposta JSON deve conter:
    """
    {
      "errors": ["Cheques can't be blank"]
    }
    """


  Cenário: Calcular um borderô com o cheque sem valor

    Quando eu enviar um POST para "/borderos/preview" com o JSON:
    """
    {
      "exchange_date": "2025-11-27",
      "monthly_interest": 2.5,
      "cheques": 
      [
          {
              "due_date": 5000.00,
              "processing_days": 2
          }
      ]
    }
    """
    Então a resposta deve ser 400
    E a resposta JSON deve conter:
    """
    {
      "errors": [
        "Cheque 1: Value can't be blank",
        "Cheque 1: Value is not a number"
      ]
    }
    """


   Cenário: Calcular um borderô com o cheque sem data de vencimento

    Quando eu enviar um POST para "/borderos/preview" com o JSON:
    """
    {
      "exchange_date": "2025-11-27",
      "monthly_interest": 2.5,
      "cheques": 
      [
          {
              "value": 5000.00,
              "processing_days": 2
          }
      ]
    }
    """
    Então a resposta deve ser 400
    E a resposta JSON deve conter:
    """
    {
      "errors": [
        "Cheque 1: Due date can't be blank"
      ]
    }
    """


  Cenário: Calcular um borderô com o cheque sem dias de processamento

    Quando eu enviar um POST para "/borderos/preview" com o JSON:
    """
    {
      "exchange_date": "2025-11-27",
      "monthly_interest": 2.5,
      "cheques": 
      [
          {
              "value": 5000.00,
              "due_date": "2026-01-13"
          }
      ]
    }
    """
    Então a resposta deve ser 400
    E a resposta JSON deve conter:
    """
    {
      "errors": [
        "Cheque 1: Processing days can't be blank",
        "Cheque 1: Processing days is not a number"
      ]
    }
    """

  Cenário: Calcular um borderô com taxa de juros negativa
    Quando eu enviar um POST para "/borderos/preview" com o JSON:
    """
    {
      "exchange_date": "2026-01-15",
      "monthly_interest": -2.5,
      "cheques": 
      [
        {
          "value": 5000.00,
          "due_date": "2026-02-13",
          "processing_days": 2
        }
      ]
    }
    """
    Então a resposta deve ser 400
    E a resposta JSON deve conter:
    """
    {
      "errors": [
        "Monthly interest must be greater than 0"
      ]
    }
    """

  Cenário: Calcular um borderô com valor de cheque negativo
    Quando eu enviar um POST para "/borderos/preview" com o JSON:
    """
    {
      "exchange_date": "2026-01-15",
      "monthly_interest": 2.5,
      "cheques": 
      [
        {
          "value": -5000.00,
          "due_date": "2026-02-13",
          "processing_days": 2
        }
      ]
    }
    """
    Então a resposta deve ser 400
    E a resposta JSON deve conter:
    """
    {
      "errors": [
        "Cheque 1: Value must be greater than 0"
      ]
    }
    """

  Cenário: Calcular um borderô com múltiplos cheques inválidos
    Quando eu enviar um POST para "/borderos/preview" com o JSON:
    """
    {
      "exchange_date": "2026-01-15",
      "monthly_interest": 2.5,
      "cheques": 
      [
        {
          "value": 0,
          "due_date": "2026-02-13",
          "processing_days": 2
        },
        {
          "value": 5000.00,
          "due_date": "2026-00-13",
          "processing_days": 2
        },
        {
          "value": 3000.00,
          "due_date": "2026-03-13",
          "processing_days": -5
        }
      ]
    }
    """
    Então a resposta deve ser 400
    E a resposta JSON deve conter:
    """
    {
      "errors": [
        "Cheque 1: Value must be greater than 0",
        "Cheque 2: Due date can't be blank",
        "Cheque 2: Due date is not a valid date",
        "Cheque 3: Processing days must be greater than or equal to 0"
      ]
    }
    """

  Cenário: Calcular um borderô com cheque com todos os campos inválidos
    Quando eu enviar um POST para "/borderos/preview" com o JSON:
    """
    {
      "exchange_date": "2026-01-15",
      "monthly_interest": 2.5,
      "cheques": 
      [
        {
          "value": -100.00,
          "due_date": "2026-13-45",
          "processing_days": -10
        }
      ]
    }
    """
    Então a resposta deve ser 400
    E a resposta JSON deve conter:
    """
    {
      "errors": [
        "Cheque 1: Value must be greater than 0",
        "Cheque 1: Due date can't be blank",
        "Cheque 1: Processing days must be greater than or equal to 0",
        "Cheque 1: Due date is not a valid date"
      ]
    }
    """

  Cenário: Calcular um borderô com juros mensais como string não numérica
    Quando eu enviar um POST para "/borderos/preview" com o JSON:
    """
    {
      "exchange_date": "2026-01-15",
      "monthly_interest": "abc",
      "cheques": 
      [
        {
          "value": 5000.00,
          "due_date": "2026-02-13",
          "processing_days": 2
        }
      ]
    }
    """
    Então a resposta deve ser 400
    E a resposta JSON deve conter:
    """
    {
      "errors": [
        "Monthly interest must be greater than 0"
      ]
    }
    """

  Cenário: Calcular um borderô com valor do cheque como string não numérica
    Quando eu enviar um POST para "/borderos/preview" com o JSON:
    """
    {
      "exchange_date": "2026-01-15",
      "monthly_interest": 2.5,
      "cheques": 
      [
        {
          "value": "abc",
          "due_date": "2026-02-13",
          "processing_days": 2
        }
      ]
    }
    """
    Então a resposta deve ser 400
    E a resposta JSON deve conter:
    """
    {
      "errors": [
        "Cheque 1: Value must be greater than 0"
      ]
    }
    """

  Cenário: Calcular um borderô com dias de processamento como string não numérica
    Quando eu enviar um POST para "/borderos/preview" com o JSON:
    """
    {
      "exchange_date": "2026-01-15",
      "monthly_interest": 2.5,
      "cheques": 
      [
        {
          "value": 5000.00,
          "due_date": "2026-02-13",
          "processing_days": "abc"
        }
      ]
    }
    """
    Então a resposta deve ser 400
    E a resposta JSON deve conter:
    """
    {
      "errors": [
        "Cheque 1: Processing days is not a number"
      ]
    }
    """

# language: pt

Funcionalidade: Borderô

  Contexto:
    Dado que a data atual é "2025-11-26 12:00:00"
  
  Cenário: Calcular um borderô
    Quando eu enviar um POST para "/borderos/preview" com o JSON:
      """
        {
            "exchange_date": "2025-11-27",
            "monthly_interest": 2.5,
            "cheques": [
                {
                    "value": 5000.00,
                    "due_date": "2026-01-13",
                    "processing_days": 2
                }
            ]
        }
      """
    Então a resposta deve ser 200
    E todos os cheques devem estar em dias úteis
    E a resposta JSON deve conter:
    """
    {
        "exchange_date":"2025-11-27", 
        "monthly_interest":"2.5",
        "total_amount":"5000.0",
        "cheques":
        [
            {
                "value":"5000.0",
                "due_date":"2026-01-13",
                "effective_due_date":"2026-01-15",
                "processing_days":2,
                "days_count":49,
                "total_interest":"4.08333",
                "paid_for_exchange":"204.17",
                "amount_to_receive":"4795.83"
            }
        ] 
    }
    """


    Cenário: Calcular um borderô com data caindo em final de semana
    Quando eu enviar um POST para "/borderos/preview" com o JSON:
      """
        {
            "exchange_date": "2025-11-27",
            "monthly_interest": 2.5,
            "cheques": [
                {
                    "value": 3000.00,
                    "due_date": "2026-01-15",
                    "processing_days": 2
                }
            ]
        }
      """
    Então a resposta deve ser 200
    E todos os cheques devem estar em dias úteis
    E a resposta JSON deve conter:
    """
    {
        "exchange_date":"2025-11-27", 
        "monthly_interest":"2.5",
        "total_amount":"3000.0",
        "cheques":
        [
            {
                "value":"3000.0",
                "due_date":"2026-01-15",
                "effective_due_date":"2026-01-19",
                "processing_days":2,
                "days_count":53,
                "total_interest":"4.41667",
                "paid_for_exchange":"132.5",
                "amount_to_receive":"2867.5"
            }
        ] 
    }
    """

  Cenário: Calcular um borderô com data caindo em feriado

    Dado que "2026-01-19" é um feriado bancário
    Quando eu enviar um POST para "/borderos/preview" com o JSON:
      """
        {
            "exchange_date": "2025-11-27",
            "monthly_interest": 2.5,
            "cheques": [
                {
                    "value": 3000.00,
                    "due_date": "2026-01-15",
                    "processing_days": 2
                }
            ]
        }
      """
    Então a resposta deve ser 200
    E todos os cheques devem estar em dias úteis
    E a resposta JSON deve conter:
    """
    {
        "exchange_date":"2025-11-27", 
        "monthly_interest":"2.5",
        "total_amount":"3000.0",
        "cheques":
        [
            {
                "value":"3000.0",
                "due_date":"2026-01-15",
                "effective_due_date":"2026-01-20",
                "processing_days":2,
                "days_count":54,
                "total_interest":"4.5",
                "paid_for_exchange":"135.0",
                "amount_to_receive":"2865.0"
            }
        ] 
    }
    """

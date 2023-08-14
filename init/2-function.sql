-- Schedule (PostgreSQL 10)
CREATE TABLE "public"."lock" (
  "attr" character NOT NULL,
  "#t" integer NOT NULL,
  CONSTRAINT "lock_pkey" PRIMARY KEY ("attr")
);

CREATE OR REPLACE FUNCTION "testeScheduleEstrito"()
RETURNS BOOLEAN AS $$
  DECLARE
    numtransaction INTEGER;
    typeAction CHARACTER;
    variable CHARACTER;
    searchtransaction INTEGER;

  BEGIN
    
    FOR numtransaction, typeAction, variable IN SELECT "#t", "op" , "attr" 
                 FROM "Schedule"

    LOOP
      IF typeAction = 'R' OR typeAction = 'W' THEN -- Read or Write

        SELECT "#t" INTO searchtransaction FROM lock WHERE "attr" = variable ;

        IF FOUND THEN 
        
          -- Um processo diferente do que bloqueou que está solicitando a variável
          IF searchtransaction <> numtransaction THEN
            RETURN FALSE;
          
          -- else :  mesmo processo, não tem problema
          END IF;

        ELSE 

          IF typeAction = 'W' THEN --Não existe block nessa variável --> se escrever --> blocar

            INSERT INTO lock ("attr" ,"#t") VALUES (variable,numtransaction);

          END IF;

        END IF;

      ELSIF typeAction = 'A' OR typeAction = 'C' THEN -- Abort and Commit

        -- retira todos os blocks daquela transação
        DELETE FROM lock WHERE "#t" = numtransaction;

      END IF;

    END LOOP;

    RETURN TRUE;

  END;
$$ LANGUAGE plpgsql;


-- calling function
SELECT "testeScheduleEstrito"() AS resp;
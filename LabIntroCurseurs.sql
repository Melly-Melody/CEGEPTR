------------------------------
-- Nathan Gendron           --
-- Pierre-Olivier Lafrenaye --
------------------------------

set serveroutput on;

-- 1
declare
	cursor c_Professeurs is
		select Nom, Prenom, Nom_Departement, Salaire
		from Personnes pe, Professeurs pr, Departements d
		where Pe.NAS = Pr.NAS and Pr.No_Departement = D.No_Departement
		for update of Pr.Salaire;
	v_Professeurs c_professeurs%rowtype;
begin
	if c_Professeurs%isopen = false then
		open c_Professeurs;
	end if;
	loop
		fetch c_Professeurs into v_Professeurs;
		exit when c_Professeurs%notfound;
		
		case upper(v_Professeurs.Nom_Departement)
			when 'INFORMATIQUE' then 
				v_Professeurs.salaire:=v_Professeurs.salaire+(v_Professeurs.Salaire*0.045);
			when 'MATHÉMATIQUES' then
				v_professeurs.salaire:=v_Professeurs.salaire+(v_Professeurs.Salaire*0.05);
			when 'PHARMACIE' then
				v_professeurs.salaire:=v_Professeurs.salaire+(v_Professeurs.Salaire*0.03);
			else
				v_professeurs.salaire:=v_Professeurs.salaire+(v_Professeurs.Salaire*0.02);
		end case;
		Update Professeurs set Salaire=v_Professeurs.Salaire where current of c_Professeurs;
		dbms_output.put_line(v_Professeurs.nom||', '||v_Professeurs.prenom||' - '||v_Professeurs.Nom_Departement||'  '||to_Char(v_Professeurs.salaire, '$999G999'));
	end loop;
	if c_Professeurs%IsOpen=true then 
		close c_Professeurs;
	end if;
end;
/
/*
declare
  cursor c_Professeurs is
	select Nom, Prenom, Nom_Departement, Salaire
	from Personnes pe, Professeurs pr, Departements d
	where Pe.NAS = Pr.NAS and Pr.No_Departement = D.No_Departement
	for update of Pr.Salaire;
  v_Professeurs c_professeurs%rowtype;

begin
  for v_Professeurs in c_Professeurs loop
	case upper(v_Professeurs.Nom_Departement)
	  when 'INFORMATIQUE' then 
		v_Professeurs.salaire:=v_Professeurs.salaire+(v_Professeurs.Salaire*0.045);
	  when 'MATHÉMATIQUES' then
		v_professeurs.salaire:=v_Professeurs.salaire+(v_Professeurs.Salaire*0.05);
	  when 'PHARMACIE' then
		v_professeurs.salaire:=v_Professeurs.salaire+(v_Professeurs.Salaire*0.03);
	  else
		v_professeurs.salaire:=v_Professeurs.salaire+(v_Professeurs.Salaire*0.02);
	end case;
	Update Professeurs set Salaire=v_Professeurs.Salaire where current of c_Professeurs;
	dbms_output.put_line(v_Professeurs.nom||', '||v_Professeurs.prenom||' - '||v_Professeurs.Nom_Departement||'  '||to_Char(v_Professeurs.salaire, '$999G999'));
  end loop;
end;
/
*/
-- 2
declare
	  cursor c_Salaires is
		select Nom_Departement, Sum(Salaire)as SalaireSum
		from Professeurs Pr, Departements D
		where Pr.No_Departement=D.No_Departement
		group by Nom_Departement
		order by Nom_Departement;
	  v_Salaires c_Salaires%rowtype;
begin
	if c_Salaires%isopen = false
		then open c_Salaires;
	end if;
	loop
		fetch c_Salaires into v_Salaires;
		exit when c_Salaires%notfound;
		dbms_output.put_line(v_Salaires.Nom_Departement||'     '||to_Char(v_Salaires.SalaireSum,'$999G999'));
	end loop;
	if c_Salaires%IsOpen=true then 
		close c_Salaires;
	end if;
end;
/
/*
declare
  cursor c_Salaires is
	select Nom_Departement, Sum(Salaire)as SalaireSum
	from Professeurs Pr, Departements D
	where Pr.No_Departement=D.No_Departement
	group by Nom_Departement
	order by Nom_Departement;
  v_Salaires c_Salaires%rowtype;
begin
  for v_Salaires into c_Salaires loop
	dbms_output.put_line(v_Salaires.Nom_Departement||'     '||to_Char(v_Salaires.SalaireSum,'$999G999'));
  end loop;
end;
/
*/

-- 3
/* JE SUIS ICI!!!
create or replace function Modifier_Codes (p_NAS as Personnes.NAS%type)
OUI OUI, ICI, JUSTE EN HAUT! REGARDE!!!*/
create or replace procedure Ajuster_Codes_TR is
	cursor c_Infos is
		select NAS, Ville, Code_Postal
		from Personnes;
	v_Infos c_Infos%RowType
begin
	if c_Infos%IsOpen=False then
		open c_Infos;
	end if;
	loop
		fetch c_Infos into v_Infos;
		exit when c_infos%NOTFOUND;
		if upper(v_Infos.Ville)='TROIS_RIVIÈRES' then
			v_Infos.Code_Postal:= Modifier_Codes(v_Infos.NAS);
		end if;
	end loop;
end;
/
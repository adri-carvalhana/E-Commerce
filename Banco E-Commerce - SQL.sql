-- Criação do banco de dados para o cenário de E-Commerce
CREATE database ECommerce;
use ECommerce;

-- Criar tabela Cliente - ok
create table clients(
	idClient int auto_increment primary key,
	Fname varchar(10),
	Minit char(3),
	Lname varchar(20),
	CPF char(11) not null,
	Address varchar(45),
	constraint unique_cpf_client unique (CPF)
);

alter table clients auto_increment=1;
-- desc clients;

-- Criar tabela Produto - ok
create table product(
	idProduct int auto_increment primary key,
	Pname varchar(10),
	Classification_Kids bool,
	Category enum('Eletrênicos' , 'Vestuário' , 'Brinquedos' , 'Alimentos' , 'Móveis') not null,
	CPF char(11) not null,
	Avaliação float default 0,
	Size varchar(10),
	constraint unique_cpf_client unique (CPF)
);
alter table product auto_increment=1;

-- Criar tabela Pedido - ok
create table orders(
	idOrder int auto_increment primary key,
	idOrderClient int,
	OrderStatus enum('Cancelado', 'Confirmado', 'Em processamento') default 'Em processamento',
	OrderDescription varchar(255),
	sendValue float default 10,
	paymentCash bool default false,
	constraint fk_ordes_client foreign key (idOrderClient) references Clients (idClient)
    on update cascade
);
alter table orders auto_increment=1;

-- Criar tabela Pagamentos
-- Termine de implementar a tabela e crie a conexão com as tabelas necessárias. Reflita a modificação no esquema relacional

create table Payments(
	idClient int,
	idPayment int,
	typePayment enum('Boleto' , 'Cartão' , 'Dois Cartões'),
	limitAvailable float,
	primary key(idClient, idPayment)
);
alter table ProductStorage rename column StorageLocaion to StorageLocation;
-- Criar tabela Estoque - ok
create table ProductStorage(
	idProdStorage int auto_increment primary key,
	StorageLocaion varchar(255),
	Quantity int default 0
);
alter table ProductStorage auto_increment=1;
desc ProductStorage;

-- Criar tabela Fornecedor - ok
create table Supplier(
	idSupplier int auto_increment primary key,
	SocialName varchar(255) not null,
	CNPJ char(15) not null,
	Contact char(15) not null,
	constraint unique_supplier unique (CNPJ)
);
alter table Supplier auto_increment=1;

-- Criar tabela Vendedor - ok
create table Seller(
	idSeller int auto_increment primary key,
	SocialName varchar(255) not null,
	AbstName varchar(255),
	CNPJ char(15), 
	CPF char(9), 
	Localition varchar(255),
	Contact char(15) not null,
	constraint unique_cnpj_seller unique (CNPJ), 
	constraint unique_cpf_seller unique (CPF)
);
alter table Seller auto_increment=1;

-- Criar tabela Produto Vendedor - ok
create table ProductSeller(
	idPSeller int,
	idPproduct int,
	proQuantity int default 1,
	primary key (idPSeller, idPproduct),
	constraint fk_product_seller foreign key (idPSeller) references seller(idSeller), 
	constraint fk_product_product foreign key (idPproduct) references product(idProduct)
);

-- Criar tabela Produto/Pedido - ok
create table productOrder(
idPOproduct int,
idPOorder int,
PoQuantity int default 1,
poStatus enum('Disponível' , 'Sem estoque') default 'Disponível',
primary key (idPOproduct, idPOorder),
constraint fk_productorder_seller foreign key (idPOproduct) references product(idProduct), 
constraint fk_productorder_product foreign key (idPOorder) references orders(idOrder)
);
ALTER TABLE SorageLocation RENAME StorageLocation;
-- Criar tabela Produto/Estoque - ok
create table SorageLocation(
idLproduct int,
idLstorage int,
Location varchar(255) not null,
primary key (idLproduct, idLstorage),
constraint fk_storage_location_prodtuct foreign key (idLproduct) references product(idProduct), 
constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProdStorage)
);
    
-- Criar tabela Produto/Fornecedor - 
create table productSupplier(
	idPsSupplier int,
	idPsProduct int,
	Quantity int not null,
	primary key (idPsSupplier, idPsProduct),
	constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier), 
	constraint fk_product_supplier_product foreign key (idPsProduct) references product(idProduct)
);

SHOW TABLES;

show databases;

use information_schema;
show tables;
desc referential_constraints; 
select * from referential_constraints where constraint_schema = 'ecommerce';

-- Inserção de dados
use ecommerce;
desc clients;
insert into Clients (Fname, Minit, Lname, CPF, Address)
	values ('Adriano','L', 'Carvalhana', '24713865800', 'Rua Francisco da Cruz Mellão, 100, SP'),
		('Renata','L', 'Carvalhana', '14713865800', 'Rua Açucena Branca, 50 - SP'),
        ('Giselle','L', 'Carvalhana', '34713865800', 'Rua Mauel, 10 - São Manuel - SP');
        
select * from clients;

desc product;
insert into product (Pname, Classification_Kids, Category, CPF, Avaliação, Size) 
values	('Fone',false,'Eletrênicos', '12345678910','4', null),
    ('Barbie',true,'Brinquedos', '12345678911', '3', null),
    ('Sofa',false,'Móveis', '12345678912', '3', '3x57x80');
       
select * from product;

desc orders;
delete from orders where idOrderClient in (1,2,3);
insert into orders (idOrderClient, OrderStatus, OrderDescription, sendValue, paymentCash) 
values	(1, default,'Compra via Aplicativo', null,1),
    (2,'Confirmado',null,null,1),
    (3, default, 'Compra via web site', 150,0);

select * from orders;

desc productOrder;
insert into productOrder (idPOproduct, idPOorder, PoQuantity, poStatus) values	
	(1,5,2, null),
    (2,5,1,null),
    (3,6,1, null);

select * from productOrder;

desc ProductStorage;
insert into ProductStorage (StorageLocation, Quantity) values	
	('Rio de Janeiro', 1000),
    ('São Paulo', 500),
    ('Espirito Santo', 200);

select * from ProductStorage;

desc StorageLocation;
insert into StorageLocation (idLProduct, idLStorage, Location) values	
	(1,2, 'RJ'),
    (2,6, 'GO');

select * from StorageLocation;

desc Supplier;
insert into Supplier (SocialName, CNPJ, Contact) values	
	('Almeida e Filhos', '1234567891234','55117275'),
    ('Carvalhana e Filhos', '1234567891236','55117276'),
    ('Santos e Filhos', '1234567891237','55117277');

select * from Supplier;

select * from product;
desc productSupplier;
insert into productSupplier (idPsSupplier, idPsProduct, Quantity) values	
	(1,1,500),
    (1,2,400),
    (2,3,633);

select * from productSupplier;

desc Seller;
insert into Seller (SocialName, AbstName, CNPJ, CPF, Localition, Contact) values	
	('Tech Eletrônicos', null, 1234567891234, null, 'Rio de Janeiro', 80311214),
    ('Adri Eletrônicos', null, null, 471386580, 'Rio de Janeiro', 80311215),
    ('Carina Eletronicos', null, 1234567891236, null, 'Rio de Janeiro', 70331210);

select * from Seller;

desc Seller;
insert into Seller (SocialName, AbstName, CNPJ, CPF, Localition, Contact) values	
	('Tech Eletrônicos', null, 1234567891234, null, 'Rio de Janeiro', 80311214),
    ('Adri Eletrônicos', null, null, 471386580, 'Rio de Janeiro', 80311215),
    ('Carina Eletronicos', null, 1234567891236, null, 'Rio de Janeiro', 70331210);

select * from ProductSeller;
desc ProductSeller;
insert into ProductSeller (idPSeller, idPproduct, proQuantity) values	
	(22,2,80),
    (23,3,10);

select count(*) from Clients;

select * from  clients c, orders o where c.idClient = idOrderClient;
select Fname, Lname, idOrder, orderStatus from  clients c, orders o where c.idClient = idOrderClient;
select concat (Fname,' ', Lname) as Client, idOrder as Request, orderStatus as Status from  clients c, orders o where c.idClient = idOrderClient;




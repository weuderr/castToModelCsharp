create table dbo.AdmClientApi
(
    Id                   nvarchar(128) not null
        constraint PK_AdmClientApi
            primary key,
    Secret               nvarchar(max) not null,
    Name                 nvarchar(100) not null,
    ApplicationType      int           not null,
    Active               bit           not null,
    RefreshTokenLifeTime int           not null,
    AllowedOrigin        nvarchar(100)
);

create table dbo.AdmRefreshToken
(
    Id              nvarchar(128) not null
        constraint PK_AdmRefreshToken
            primary key,
    Subject         nvarchar(50)  not null,
    ClientId        nvarchar(50)  not null,
    IssuedUtc       datetime      not null,
    ExpiresUtc      datetime      not null,
    ProtectedTicket nvarchar(max) not null
);

create table dbo.AdmRole
(
    Id            nvarchar(128) not null
        constraint PK_AdmRole
            primary key,
    Name          nvarchar(256) not null,
    Description   nvarchar(256),
    Discriminator nvarchar(128) not null
);

create table dbo.AdmRoleClaim
(
    Id                 int identity
        constraint PK_AdmRoleClaim
        primary key,
    ClaimType          nvarchar(max),
    ClaimValue         nvarchar(max),
    ApplicationRole_Id nvarchar(128)
        constraint FK_dbo_AdmRoleClaim_dbo_AdmRole_ApplicationRole_Id
            references dbo.AdmRole
);

create index IX_FK_dbo_AdmRoleClaim_dbo_AdmRole_ApplicationRole_Id
    on dbo.AdmRoleClaim (ApplicationRole_Id);

create table dbo.AdmUser
(
    Id                   nvarchar(128) not null
        constraint PK_AdmUser
            primary key,
    Nome                 nvarchar(150),
    CpfCnpj              nvarchar(14)  not null,
    Ativo                bit           not null,
    AssinanteId          int           not null,
    EmpresaId            int           not null,
    CurrentClientId      nvarchar(10),
    Email                nvarchar(256),
    EmailConfirmed       bit           not null,
    PasswordHash         nvarchar(max),
    SecurityStamp        nvarchar(max),
    PhoneNumber          nvarchar(max),
    PhoneNumberConfirmed bit           not null,
    TwoFactorEnabled     bit           not null,
    LockoutEndDateUtc    datetime,
    LockoutEnabled       bit           not null,
    AccessFailedCount    int           not null,
    UserName             nvarchar(256) not null,
    DataUltimoAcesso     datetime,
    StatusAcesso         nvarchar(20),
    AppVersao            nvarchar(20),
    DataBloqueio         datetime,
    MotivoBloqueio       varchar(255)
);

create table dbo.AdmUserClaim
(
    Id         int identity
        constraint PK_AdmUserClaim
        primary key,
    UserId     nvarchar(128) not null
        constraint FK_dbo_AdmUserClaim_dbo_AdmUser_UserId
            references dbo.AdmUser,
    ClaimType  nvarchar(max),
    ClaimValue nvarchar(max)
);

create index IX_FK_dbo_AdmUserClaim_dbo_AdmUser_UserId
    on dbo.AdmUserClaim (UserId);

create table dbo.AdmUserClient
(
    ClientId           int identity
        constraint PK_AdmUserClient
        primary key,
    ClientSession      nvarchar(255) not null,
    ClientIp           nvarchar(50)  not null,
    ClientBrowser      nvarchar(50)  not null,
    Updated         datetime      not null,
    AccessToken        nvarchar(max),
    ApplicationUser_Id nvarchar(128)
        constraint FK_dbo_AdmUserClient_dbo_AdmUser_ApplicationUser_Id
            references dbo.AdmUser
);

create index IX_FK_dbo_AdmUserClient_dbo_AdmUser_ApplicationUser_Id
    on dbo.AdmUserClient (ApplicationUser_Id);

create table dbo.AdmUserLogin
(
    LoginProvider nvarchar(128) not null,
    ProviderKey   nvarchar(128) not null,
    UserId        nvarchar(128) not null
        constraint FK_dbo_AdmUserLogin_dbo_AdmUser_UserId
            references dbo.AdmUser,
    constraint PK_AdmUserLogin
        primary key (LoginProvider, ProviderKey, UserId)
);

create index IX_FK_dbo_AdmUserLogin_dbo_AdmUser_UserId
    on dbo.AdmUserLogin (UserId);

create table dbo.AdmUserRole
(
    AdmRole_Id nvarchar(128) not null
        constraint FK_AdmUserRole_AdmRole
            references dbo.AdmRole,
    AdmUser_Id nvarchar(128) not null
        constraint FK_AdmUserRole_AdmUser
            references dbo.AdmUser,
    constraint PK_AdmUserRole
        primary key (AdmRole_Id, AdmUser_Id)
);

create index IX_FK_AdmUserRole_AdmUser
    on dbo.AdmUserRole (AdmUser_Id);

create table dbo.AppArea
(
    CodigoAppArea         nvarchar(20) not null
        constraint PK_AppArea
            primary key,
    Descricao             nvarchar(50) not null,
    ServicoComunicacaoEml int
);

create table dbo.AppEvento
(
    CodigoAppEvento nvarchar(50) not null
        constraint PK_AppEvento
            primary key,
    ClaimType       nvarchar(50) not null,
    ClaimValue      nvarchar(50) not null,
    Descricao       nvarchar(100)
);

create table dbo.AppMenu
(
    CodigoAppArea nvarchar(20) not null
        constraint FK_AppMenu_AppArea
            references dbo.AppArea,
    CodigoAppMenu nvarchar(20) not null,
    Descricao     nvarchar(50) not null,
    Ordem         int,
    constraint PK_AppMenu
        primary key (CodigoAppArea, CodigoAppMenu)
);

create table dbo.AppMenuItem
(
    CodigoAppArea     nvarchar(20) not null,
    CodigoAppMenu     nvarchar(20) not null,
    CodigoAppMenuItem nvarchar(20) not null,
    Descricao         nvarchar(50) not null,
    constraint PK_AppMenuItem
        primary key (CodigoAppArea, CodigoAppMenu, CodigoAppMenuItem),
    constraint FK_AppMenuItem_AppMenu
        foreign key (CodigoAppArea, CodigoAppMenu) references dbo.AppMenu
);

create table dbo.AppRotina
(
    CodigoAppRotina   int          not null
        constraint PK_AppRotina
            primary key,
    CodigoAppArea     nvarchar(20) not null,
    CodigoAppMenu     nvarchar(20) not null,
    CodigoAppMenuItem nvarchar(20) not null,
    NomeRotina        nvarchar(50) not null,
    Descricao         nvarchar(50),
    constraint FK_AppRotina_AppMenuItem
        foreign key (CodigoAppArea, CodigoAppMenu, CodigoAppMenuItem) references dbo.AppMenuItem
);

create index IX_FK_AppRotina_AppMenuItem
    on dbo.AppRotina (CodigoAppArea, CodigoAppMenu, CodigoAppMenuItem);

create table dbo.AppRotinaEvento
(
    CodigoAppRotina int          not null
        constraint FK_TabAppRotinaEvento_AppRotina
            references dbo.AppRotina,
    CodigoAppEvento nvarchar(50) not null
        constraint FK_TabAppRotinaEvento_AppEvento
            references dbo.AppEvento,
    constraint PK_AppRotinaEvento
        primary key (CodigoAppRotina, CodigoAppEvento)
);

create index IX_FK_TabAppRotinaEvento_AppEvento
    on dbo.AppRotinaEvento (CodigoAppEvento);

create table dbo.C__MigrationHistory
(
    MigrationId    nvarchar(150)  not null,
    ContextKey     nvarchar(300)  not null,
    Model          varbinary(max) not null,
    ProductVersion nvarchar(32)   not null,
    constraint PK_C__MigrationHistory
        primary key (MigrationId, ContextKey)
);

create table dbo.CadAssinante
(
    CadAssinanteId        int identity
        constraint PK_CadAssinante
        primary key,
    CNPJ_CPF              nvarchar(14)  not null,
    Nome                  nvarchar(100) not null,
    CRCNumero             nvarchar(20)  not null,
    CRCUF                 nvarchar(2)   not null,
    Ativo                 bit           not null,
    AdminEmail            nvarchar(255) not null,
    QtdMaxUsuario         int           not null,
    Created            datetime      not null,
    DateFimTeste          datetime      not null,
    DateIniContrato       datetime      not null,
    DateFimContrato       datetime      not null,
    NomeFantasia          nvarchar(50)  not null,
    InscricaoEstadual     nvarchar(20)  not null,
    Setor                 nvarchar(50)  not null,
    Telefone              nvarchar(15)  not null,
    EnderecoLogradouro    nvarchar(150) not null,
    EnderecoNumero        nvarchar(6)   not null,
    EnderecoComplemento   nvarchar(50)  not null,
    EnderecoBairro        nvarchar(50)  not null,
    EnderecoMunicipioIBGE nchar(7)      not null,
    EnderecoUF            nchar(2)      not null,
    EnderecoCEP           nvarchar(8)   not null,
    EnderecoPaisIBGE      nvarchar(10)  not null,
    EmTeste               bit,
    DataBloqueio          datetime,
    DataCancelamento      datetime,
    MotivoBloqueio        varchar(255),
    MotivoCancelamento    varchar(255),
    PlanoAtual            varchar(255)
);

create table dbo.CadAssinantePerfil
(
    CadAssinanteId       int          not null
        constraint FK_CadAssinantePerfil_CadAssinante
            references dbo.CadAssinante,
    CadAssinantePerfilId nvarchar(50) not null,
    ClaimType            nvarchar(20) not null,
    ClaimValue           nvarchar(20) not null,
    constraint PK_CadAssinantePerfil
        primary key (CadAssinanteId, CadAssinantePerfilId)
);

create table dbo.AdmUserPerfil
(
    CadAssinanteId       int           not null,
    CadAssinantePerfilId nvarchar(50)  not null,
    AdmUserId            nvarchar(128) not null,
    constraint PK_AdmUserPerfil
        primary key (CadAssinanteId, CadAssinantePerfilId, AdmUserId),
    constraint FK_AdmUserPerfil_CadAssinantePerfil
        foreign key (CadAssinanteId, CadAssinantePerfilId) references dbo.CadAssinantePerfil
);

create table dbo.AppPerfilRotina
(
    CadAssinanteId       int          not null,
    CadAssinantePerfilId nvarchar(50) not null,
    CodigoAppRotina      int          not null
        constraint FK_AppPerfilRotina_AppRotina
            references dbo.AppRotina,
    CodigoAppEvento      nvarchar(50) not null
        constraint FK_AppPerfilRotina_AppEvento
            references dbo.AppEvento,
    constraint PK_AppPerfilRotina
        primary key (CadAssinanteId, CadAssinantePerfilId, CodigoAppRotina, CodigoAppEvento),
    constraint FK_AppPerfilRotina_CadAssinantePerfil
        foreign key (CadAssinanteId, CadAssinantePerfilId) references dbo.CadAssinantePerfil
);

create index IX_FK_AppPerfilRotina_AppEvento
    on dbo.AppPerfilRotina (CodigoAppEvento);

create index IX_FK_AppPerfilRotina_AppRotina
    on dbo.AppPerfilRotina (CodigoAppRotina);

create table dbo.CadCatalogoLayout
(
    CadCatalogoLayoutId int not null
        constraint PK_CadCatalogoLayout
            primary key,
    Descricao           nvarchar(100)
);

create table dbo.CadCatalogo
(
    CadCatalogoId       int           not null
        constraint PK_CadCatalogo
            primary key,
    CadEmpresaId        int           not null,
    Nome                nvarchar(100) not null,
    Descricao           nvarchar(500) not null,
    CadCatalogoLayoutId int           not null
        constraint FK_CadCatalogo_CadCatalogoLayout
            references dbo.CadCatalogoLayout,
    MarcaComercial      nvarchar(60)  not null,
    Observacao          nvarchar(500) not null
);

create index IX_FK_CadCatalogo_CadCatalogoLayout
    on dbo.CadCatalogo (CadCatalogoLayoutId);

create table dbo.CadCatalogoItem
(
    CadCatalogoItemId int           not null
        constraint PK_CadCatalogoItem
            primary key,
    CadCatalogoId     int           not null
        constraint FK_CadCatalogoItem_CadCatalogo
            references dbo.CadCatalogo,
    CadItemId         bigint        not null,
    CodigoCatalogo    nvarchar(20)  not null,
    Cor               nvarchar(20)  not null,
    NomeProduto       nvarchar(100) not null,
    PathImagem        nvarchar(255) not null,
    Descricao         nvarchar(500) not null
);

create index IX_FK_CadCatalogoItem_CadCatalogo
    on dbo.CadCatalogoItem (CadCatalogoId);

create table dbo.CadCentroResultadoGrupo
(
    CadCentroResultadoGrupoId int identity
        constraint PK_CadCentroResultadoGrupo
        primary key,
    CadAssinanteId            int          not null,
    CadEmpresaId              int          not null,
    Nome                      nvarchar(50) not null,
    Ordem                     int          not null
);

create table dbo.CadCentroResultadoSubgrupo
(
    CadCentroResultadoSubgrupoId int identity
        constraint PK_CadCentroResultadoSubgrupo
        primary key,
    CadAssinanteId               int          not null,
    CadEmpresaId                 int          not null,
    CadCentroResultadoGrupoId    int          not null
        constraint FK_CAD_CadCentroResultadoSubgrupo_CAD_CadCentroResultadoGrupo_CadCentroResultadoGrupoId
            references dbo.CadCentroResultadoGrupo,
    Nome                         nvarchar(50) not null,
    Ordem                        int          not null
);

create table dbo.CadCentroResultado
(
    CadCentroResultadoId         int identity
        constraint PK_CadCentroResultado
        primary key,
    CadAssinanteId               int          not null,
    CadEmpresaId                 int          not null,
    CadCentroResultadoGrupoId    int          not null
        constraint FK_CAD_CadCentroResultado_CAD_CadCentroResultadoGrupo_CadCentroResultadoGrupoId
            references dbo.CadCentroResultadoGrupo,
    CadCentroResultadoSubgrupoId int          not null
        constraint FK_CAD_CadCentroResultado_CAD_CadCentroResultadoSubgrupo_CadCentroResultadoSubgrupoId
            references dbo.CadCentroResultadoSubgrupo,
    Nome                         nvarchar(50) not null,
    Ordem                        int          not null
);

create index IX_FK_CAD_CadCentroResultado_CAD_CadCentroResultadoGrupo_CadCentroResultadoGrupoId
    on dbo.CadCentroResultado (CadCentroResultadoGrupoId);

create index IX_FK_CAD_CadCentroResultado_CAD_CadCentroResultadoSubgrupo_CadCentroResultadoSubgrupoId
    on dbo.CadCentroResultado (CadCentroResultadoSubgrupoId);

create index IX_FK_CAD_CadCentroResultadoSubgrupo_CAD_CadCentroResultadoGrupo_CadCentroResultadoGrupoId
    on dbo.CadCentroResultadoSubgrupo (CadCentroResultadoGrupoId);

create table dbo.CadContador
(
    CadContadorId         int identity
        constraint PK_CadContador
        primary key,
    CadAssinanteId        int           not null,
    Nome                  nvarchar(100) not null,
    RazaoSocialEscritorio nvarchar(100) not null,
    TelefoneFixo          nvarchar(20)  not null,
    TelefoneCelular       nvarchar(20)  not null,
    Email                 nvarchar(100) not null,
    Cep                   nvarchar(10)  not null,
    Logradouro            nvarchar(60)  not null,
    Numero                nvarchar(10)  not null,
    Bairro                nvarchar(50)  not null,
    Complemento           nvarchar(50)  not null,
    Cidade                nvarchar(50)  not null,
    Estado                nvarchar(2)   not null,
    CRC                   nvarchar(20)  not null
);

create table dbo.CadEmpresaAdm
(
    CadEmpresaAdmId    int identity
        constraint PK_CadEmpresaAdm
        primary key,
    CadAssinanteId     int not null,
    CNPJ               nvarchar(14),
    Razaosocial        nvarchar(100),
    NomeFantasia       nvarchar(100),
    CEP                nvarchar(10),
    logradouro         nvarchar(60),
    Numero             nvarchar(10),
    Bairro             nvarchar(60),
    CodigoTabMunicipio nchar(7),
    Cidade             nvarchar(50),
    Estado             nvarchar(2),
    Complemento        nvarchar(60),
    Telefone1          nvarchar(15),
    Telefone2          nvarchar(15),
    Observacao         nvarchar(max),
    TaxaAdministracao  decimal(18, 2)
);

create table dbo.CadEmpresaCom
(
    CadEmpresaComId               int identity
        constraint PK_CadEmpresaCom
        primary key,
    CadAssinanteId                int           not null,
    CNPJ                          nvarchar(14)  not null,
    RazaoSocial                   nvarchar(100) not null,
    NomeFantasia                  nvarchar(100) not null,
    CEP                           nvarchar(10)  not null,
    Logradouro                    nvarchar(60)  not null,
    Numero                        nvarchar(10)  not null,
    Bairro                        nvarchar(60)  not null,
    CodigoTabMunicipio            nchar(7),
    Cidade                        nvarchar(50)  not null,
    Estado                        nchar(2)      not null,
    Complemento                   nvarchar(60)  not null,
    Telefone1                     nvarchar(15)  not null,
    Telefone2                     nvarchar(15)  not null,
    Observacao                    nvarchar(max),
    Email                         nvarchar(255) not null,
    CodigoTabTipoGeraNFOperacaoId int           not null,
    IdentificacaoCSC              nvarchar(6)   not null,
    CodigoNFCe                    nvarchar(36)  not null,
    CodigoTabRegimeTributacaoId   int           not null,
    CodigoTabRegimeServicoId      int           not null,
    InscricaoEstadual             nvarchar(20)  not null,
    InscricaoMunicipal            nvarchar(20)  not null,
    PossuiEmpresaAdm              bit           not null,
    PossuiEmpresaComercio         bit           not null,
    NFCeSerie                     nvarchar(3)   not null,
    NFCeNumero                    nvarchar(10)  not null,
    NFCeAmbiente                  int           not null,
    NFeSerie                      nvarchar(3)   not null,
    NFeNumero                     nvarchar(10)  not null,
    NFeAmbiente                   int           not null,
    CertificadoPath               nvarchar(255) not null,
    CertificadoSenha              nvarchar(50)  not null,
    CertificadoDataVencimento     datetime      not null,
    TokenEmissao                  nvarchar(255) not null
);

create table dbo.CadEmpresaFilial
(
    CadEmpresaMatrizId int not null,
    CadEmpresaFilialId int not null,
    CadAssinanteId     int not null,
    constraint PK_CadEmpresaFilial
        primary key (CadEmpresaMatrizId, CadEmpresaFilialId)
);

create table dbo.CadEmpresaProfissional
(
    CadEmpresaId      int            not null,
    CadParticipanteId bigint         not null,
    DataAdmissao      datetime       not null,
    Desligado         bit            not null,
    DataDesligamento  datetime       not null,
    Remuneracao       decimal(18, 2) not null,
    constraint PK_CadEmpresaProfissional
        primary key (CadEmpresaId, CadParticipanteId)
);

create table dbo.CadFranquia
(
    CadFranquiaId int identity
        constraint PK_CadFranquia
        primary key,
    NomeFranquia  nvarchar(100) not null
);

create table dbo.CadItemFinalidade
(
    CadItemFinalidadeId     bigint identity
        constraint PK_CadItemFinalidade
        primary key,
    Descricao               nvarchar(50),
    ProdutoParaVenda        bit,
    ProdutoParaConsumo      bit,
    ValorVenda              decimal(18, 2),
    DescontoMaximoPermitido decimal(18, 2)
);

create table dbo.CadItemGrupo
(
    CodigoCadItemGrupoId int identity
        constraint PK_CadItemGrupo
        primary key,
    CadEmpresaId         int           not null,
    CadAssinanteId       int           not null,
    Nome                 nvarchar(100) not null
);

create table dbo.CadItemMetadados
(
    CadItemMetaId     bigint identity
        constraint PK_CadItemMetadados
        primary key,
    TipoMetadado      nvarchar(20) not null,
    ChaveInt          int          not null,
    ChaveString       nvarchar(80),
    DescricaoCompleta nvarchar(1024),
    DescricaoResumida nvarchar(80),
    Observacao        nvarchar(1024),
    Ativo             int          not null,
    DataCreate        datetime     not null,
    DataUpdate        datetime     not null
);

create table dbo.CadPacote
(
    CadPacoteId       int identity
        constraint PK_CadPacote
        primary key,
    CadAssinanteid    int,
    CadEmpresaId      int,
    NomePacote        nvarchar(100)  not null,
    Descricao         nvarchar(255)  not null,
    DataInicio        datetime       not null,
    DataFim           datetime       not null,
    HoraFinal         time           not null,
    Preco             decimal(18, 2) not null,
    QuantidadeVisitas int            not null,
    Ativo             bit
);

create table dbo.CadParticipanteContato
(
    CadParticipanteId        bigint        not null,
    CadParticipanteContatoId int identity,
    CadAssinanteId           int           not null,
    CadEmpresaId             int           not null,
    Nome                     nvarchar(100) not null,
    Funcao                   nvarchar(50)  not null,
    Telefone                 nvarchar(15)  not null,
    Email                    nvarchar(255) not null,
    constraint PK_CadParticipanteContato
        primary key (CadParticipanteId, CadParticipanteContatoId)
);

create table dbo.CadPlanoConta
(
    CadPlanoContaId int identity
        constraint PK_CadPlanoConta
        primary key,
    CadAssinanteId  int          not null
        constraint FK_CadPlanoConta_CadAssinante
            references dbo.CadAssinante,
    Nome            nvarchar(20) not null
);

create table dbo.CadEmpresa
(
    CadEmpresaId                         int identity
        constraint PK_CadEmpresa
        primary key,
    CadAssinanteId                       int
        constraint FK_CadEmpresa_CadAssinante
            references dbo.CadAssinante,
    CNPJ                                 nvarchar(14)   not null,
    RazaoSocial                          nvarchar(100)  not null,
    NomeFantasia                         nvarchar(100)  not null,
    CEP                                  nvarchar(10)   not null,
    Logradouro                           nvarchar(60)   not null,
    Numero                               nvarchar(10)   not null,
    Bairro                               nvarchar(60)   not null,
    CodigoTabMunicipio                   nchar(7),
    Cidade                               nvarchar(50)   not null,
    Estado                               nchar(2)       not null,
    Complemento                          nvarchar(60)   not null,
    Telefone1                            nvarchar(15),
    Telefone2                            nvarchar(15),
    CadFranquiaId                        int
        constraint FK_CadEmpresa_CadFranquia
            references dbo.CadFranquia,
    MatrizFilial                         nvarchar(15)   not null,
    AceitaFiado                          bit            not null,
    Observacao                           nvarchar(max),
    Email                                nvarchar(255)  not null,
    Ativo                                bit            not null,
    DataDesligamento                     datetime       not null,
    SituacaoEspecial                     nvarchar(20)   not null,
    Suframa                              nvarchar(9)    not null,
    CadPlanoContaId                      int
        constraint FK_CadEmpresa_CadPlanoConta
            references dbo.CadPlanoConta,
    CodigoCNAEPrincipal                  nvarchar(10)   not null,
    CadEmpresaComId                      int
        constraint FK_CadEmpresa_CadEmpresaCOM1
            references dbo.CadEmpresaCom,
    CadEmpresaAdmId                      int
        constraint FK_CadEmpresa_CadEmpresaAdm
            references dbo.CadEmpresaAdm,
    AtualizarCadastroMigrate             bit,
    PercentualTaxaAdministrativaComissao decimal(18, 2) not null,
    EmpresaIdEmissorNotaFiscal           bigint,
    DataHoraEnvioCadastroCielo           nvarchar(max),
    StatusCadastroCielo                  int,
    DadosCadastroCielo                   nvarchar(max),
    RetornoCadastroCielo                 nvarchar(max),
    DataHoraAtualizacaoCadastroCielo     datetime,
    ChaveParceriaCielo                   nvarchar(2048),
    Latitude                             decimal(8, 6),
    Longitude                            decimal(9, 6),
    CadastroAtivado                      bit,
    CupomIndicacao                       varchar(255)
);

create index IX_FK_CadEmpresa_CadAssinante
    on dbo.CadEmpresa (CadAssinanteId);

create index IX_FK_CadEmpresa_CadEmpresaAdm
    on dbo.CadEmpresa (CadEmpresaAdmId);

create index IX_FK_CadEmpresa_CadEmpresaCOM1
    on dbo.CadEmpresa (CadEmpresaComId);

create index IX_FK_CadEmpresa_CadFranquia
    on dbo.CadEmpresa (CadFranquiaId);

create index IX_FK_CadEmpresa_CadPlanoConta
    on dbo.CadEmpresa (CadPlanoContaId);

create table dbo.CadEmpresaComercio
(
    CadEmpresaId         int not null
        constraint FK_CadEmpresaComercio_CadEmpresa
            references dbo.CadEmpresa,
    CadEmpresaComercioId int not null
        constraint FK_CadEmpresaComercio_CadEmpresa1
            references dbo.CadEmpresa,
    DataCadastro         datetime,
    constraint PK_CadEmpresaComercio
        primary key (CadEmpresaId, CadEmpresaComercioId)
);

create index IX_FK_CadEmpresaComercio_CadEmpresa1
    on dbo.CadEmpresaComercio (CadEmpresaComercioId);

create table dbo.CadMarcaComercial
(
    MarcaComercial nvarchar(60) not null,
    CadEmpresaId   int          not null
        constraint FK_CadMarcaComercial_CadEmpresa1
            references dbo.CadEmpresa,
    constraint PK_CadMarcaComercial
        primary key (MarcaComercial, CadEmpresaId)
);

create index IX_FK_CadMarcaComercial_CadEmpresa1
    on dbo.CadMarcaComercial (CadEmpresaId);

create index IX_FK_CadPlanoConta_CadAssinante
    on dbo.CadPlanoConta (CadAssinanteId);

create table dbo.CadPreferencia
(
    CadEmpresaId              int,
    PadraoCorHexa             nvarchar(7) not null
        constraint PK_CadPreferencia
            primary key,
    Descricao                 nvarchar(100),
    TempoLimite               time,
    TempoInatividade          int,
    ControleAutomaticoComanda bit
);

create table dbo.CadUserPermissao
(
    CadEmpresaId      int           not null
        constraint FK_CadUserPermissao_CadEmpresa
            references dbo.CadEmpresa,
    CadUserId         nvarchar(128) not null,
    CodigoAppRotinaId int           not null
        constraint FK_CadUserPermissao_AppRotina
            references dbo.AppRotina,
    CadAssinanteId    int           not null,
    Listar            bit           not null,
    Incluir           bit           not null,
    Alterar           bit           not null,
    Excluir           bit           not null,
    constraint PK_CadUserPermissao
        primary key (CadEmpresaId, CadUserId, CodigoAppRotinaId)
);

create index IX_FK_CadUserPermissao_AppRotina
    on dbo.CadUserPermissao (CodigoAppRotinaId);

create table dbo.LogCommunicationEvents
(
    Id                          int identity
        constraint PK_LogCommunicationEvents
        primary key,
    MessageType                 nvarchar(15)  not null,
    SourcePlatform              nvarchar(5)   not null,
    OriginRoutine               nvarchar(200) not null,
    RecipientEmail              nvarchar(1000),
    RecipientPhone              nvarchar(1000),
    SenderIdentification        nvarchar(1000),
    ServiceName                 nvarchar(50)  not null,
    CommunicationDate           datetime      not null,
    ContactType                 nvarchar(50)  not null,
    ContentSent                 nvarchar(max) not null,
    CommunicationReturn         nvarchar(max),
    CommunicationStatus         nvarchar(200),
    CommunicationDetails        nvarchar(max),
    LastCommunicationStatusDate datetime,
    UserId                      nvarchar(128),
    UserName                    nvarchar(256)
);

create table dbo.LogProcessError
(
    IdProcess         int identity,
    NameProcess       varchar(50)   not null,
    NameBase          varchar(100)  not null,
    DateProcess       datetime      not null,
    NameFieldError    varchar(50),
    ValueFieldError   varchar(100),
    DescriptionError  varchar(4000) not null,
    DescriptionAction varchar(200)  not null,
    DescriptionKey    varchar(2048) not null,
    Checked           bit,
    Upd_User_Name     varchar(150),
    Upd_Date          datetime,
    constraint PK_LogProcessError
        primary key (IdProcess, NameProcess, NameBase, DateProcess, DescriptionError, DescriptionAction, DescriptionKey)
);

create table dbo.LogProcessTime
(
    DateProcess           datetime     not null,
    NameProcess           varchar(100) not null,
    NameBase              varchar(100) not null,
    NumberRecordsIncluded int,
    NumberRecordsUpdated  int,
    NumberRecordsDeleted  int,
    TimeStarted           varchar(8),
    TimeFinished          varchar(8),
    TimeElapsed           varchar(8),
    NameUser              varchar(64),
    NameComputer          varchar(100),
    Parameters            varchar(2048),
    constraint PK_LogProcessTime
        primary key (DateProcess, NameProcess, NameBase)
);

create table dbo.NossoNumero
(
    UlimoNossoNumeroGerado int not null
        constraint PK_NossoNumero
            primary key
);

create table dbo.PagamentoComissao
(
    PagamentoComissaoId bigint identity
        constraint PK_PagamentoComissao
        primary key,
    DataPagamento       datetime       not null,
    ValorTotal          decimal(18, 2) not null
);

create table dbo.ParcelaConfig
(
    ComissaoRepetidorId int not null
        constraint PK_ParcelaConfig
            primary key,
    QtdeParcelas        int not null,
    Parcela             int not null,
    Dias                int not null
);

create table dbo.ResumoDia
(
    ResumoDiaId             uniqueidentifier not null
        constraint PK_ResumoDia
            primary key,
    CadEmpresaId            int
        constraint FK_ResumoDia_CadEmpresa
            references dbo.CadEmpresa,
    Data                    datetime,
    TotalBrutoServicos      decimal(18, 2),
    TotalBrutoProdutos      decimal(18, 2),
    TotalComissaoServicos   decimal(18, 2),
    TotalComissaoProdutos   decimal(18, 2),
    TotalTaxasDebito        decimal(18, 2),
    TotalTaxasCredito       decimal(18, 2),
    AgendamentosDoDia       int,
    AgendamentosCancelados  int,
    PercentualAgendaOcupada decimal(18, 2),
    PercentualAgendaOciosa  decimal(18, 2),
    AgendamentosAtendidos   int
);

create table dbo.LiderAtendimento
(
    LiderAtendimentoId uniqueidentifier not null
        constraint PK_LiderAtendimento
            primary key,
    NomeProfissional   nvarchar(100),
    Representacao      decimal(18, 2),
    Valor              decimal(18, 2),
    ResumoDiaId        uniqueidentifier
        constraint FK_LiderAtendimento_ResumoDia
            references dbo.ResumoDia
);

create index IX_FK_LiderAtendimento_ResumoDia
    on dbo.LiderAtendimento (ResumoDiaId);

create table dbo.MeioPagamento
(
    MeioPagamentoId uniqueidentifier not null
        constraint PK_MeioPagamento
            primary key,
    Descricao       nvarchar(100),
    Valor           decimal(18, 2),
    ResumoDiaId     uniqueidentifier
        constraint FK_MeioPagamento_ResumoDia
            references dbo.ResumoDia
);

create index IX_FK_MeioPagamento_ResumoDia
    on dbo.MeioPagamento (ResumoDiaId);

create index IX_FK_ResumoDia_CadEmpresa
    on dbo.ResumoDia (CadEmpresaId);

create table dbo.SaldoContabil
(
    CadPlanoContaDetalheId int            not null,
    MesAnoFechamento       int            not null,
    SaldoInicial           decimal(18, 6) not null,
    SaldoInicialDC         char           not null,
    SaldoFinal             decimal(18, 6) not null,
    SaldoFinalDC           char           not null,
    TotalDebito            decimal(18, 6) not null,
    TotalCredito           decimal(18, 6) not null,
    TipoContabil           char           not null,
    constraint PK_SaldoContabil
        primary key (CadPlanoContaDetalheId, MesAnoFechamento, TipoContabil)
);

create table dbo.TabANPCombustivel
(
    CodigoTabANPCombustivel nchar(9)      not null
        constraint PK_TabANPCombustivel
            primary key,
    Descricao               nvarchar(100) not null,
    DataInicio              datetime      not null,
    DataFim                 datetime,
    VersaoUpdate            nvarchar(10)  not null
);

create table dbo.TabAgendaCor
(
    CodigoTabAgendaCorId int not null
        constraint PK_TabAgendaCor
            primary key,
    PadraoCorHexa        nvarchar(7),
    SemelhancaCor        nvarchar(20),
    DescricaoPreferencia nvarchar(100),
    DescricaoPadrao      nvarchar(100),
    NomeCSS              nvarchar(50),
    NomeIcone            nvarchar(14)
);

create table dbo.CadEmpresaAgendaCor
(
    CadEmpresaId         int not null
        constraint FK_CadEmpresaAgendaCor_CadEmpresa
            references dbo.CadEmpresa,
    CodigoTabAgendaCorId int not null
        constraint FK_CadEmpresaAgendaCor_TabAgendaCor
            references dbo.TabAgendaCor,
    DescricaoPreferencia nvarchar(100),
    constraint PK_CadEmpresaAgendaCor
        primary key (CadEmpresaId, CodigoTabAgendaCorId)
);

create index IX_FK_CadEmpresaAgendaCor_TabAgendaCor
    on dbo.CadEmpresaAgendaCor (CodigoTabAgendaCorId);

create table dbo.TabAgendaMotivoCancelamento
(
    CodigoMotivoCancelamento nvarchar(20)  not null
        constraint PK_TabAgendaMotivoCancelamento
            primary key,
    Descricao                nvarchar(150) not null
);

create table dbo.TabAgendaStatus
(
    CodigoTabAgendaStatusId int not null
        constraint PK_TabAgendaStatus
            primary key,
    DescricaoStatus         nvarchar(20),
    CodigoTabAgendaCorId    int
        constraint FK_TabAgendaStatus_TabAgendaCor
            references dbo.TabAgendaCor
);

create index IX_FK_TabAgendaStatus_TabAgendaCor
    on dbo.TabAgendaStatus (CodigoTabAgendaCorId);

create table dbo.TabBanco
(
    CodigoTabBanco int           not null
        constraint PK_TabBanco
            primary key,
    Nome           nvarchar(100) not null,
    Logotipo       nvarchar(255) not null,
    Codigo         nvarchar(5)   not null,
    TipoConta      nvarchar(7),
    DataInicio     datetime      not null,
    DataFim        datetime,
    VersaoUpdate   nvarchar(10)  not null
);

create table dbo.TabCEST
(
    CodigoTabCEST nvarchar(7)   not null
        constraint PK_TabCEST
            primary key,
    Descricao     nvarchar(255) not null,
    DataInicio    datetime      not null,
    DataFim       datetime      not null,
    VersaoUpdate  nvarchar(10)  not null
);

create table dbo.TabCFOP
(
    CodigoTabCFOP nchar(4)      not null
        constraint PK_TabCFOP
            primary key,
    Descricao     nvarchar(500) not null,
    DataInicio    datetime      not null,
    DataFim       datetime,
    VersaoUpdate  nvarchar(10)  not null
);

create table dbo.TabCNAE
(
    CodigoTabCNAE nvarchar(10)  not null
        constraint PK_TabCNAE
            primary key,
    Descricao     nvarchar(255) not null,
    DataInicio    datetime      not null,
    DataFim       datetime      not null,
    VersaoUpdate  nvarchar(10)  not null
);

create table dbo.CadEmpresaCNAE
(
    CadEmpresaId  int          not null
        constraint FK_CadEmpresaCNAE_CadEmpresa
            references dbo.CadEmpresa,
    CodigoTabCNAE nvarchar(10) not null
        constraint FK_CadEmpresaCNAE_TabCNAE
            references dbo.TabCNAE,
    Principal     bit          not null,
    constraint PK_CadEmpresaCNAE
        primary key (CadEmpresaId, CodigoTabCNAE)
);

create index IX_FK_CadEmpresaCNAE_TabCNAE
    on dbo.CadEmpresaCNAE (CodigoTabCNAE);

create table dbo.TabCNHCategoria
(
    CodigoTabCNHCategoria nvarchar(10) not null
        constraint PK_TabCNHCategoria
            primary key
);

create table dbo.TabCRT
(
    CodigoTabCRT bigint       not null
        constraint PK_TabCRT
            primary key,
    Nome         varchar(100) not null
);

create table dbo.TabCabeloComprimento
(
    TabCabeloComprimentoId int          not null
        constraint PK_TabCabeloComprimento
            primary key,
    Descricao              varchar(100) not null
);

create table dbo.TabCabeloCouroEstado
(
    TabCabeloCouroEstadoId int          not null
        constraint PK_TabCabeloCouroEstado
            primary key,
    Descricao              varchar(100) not null
);

create table dbo.TabCabeloEstado
(
    TabCabeloEstadoId int          not null
        constraint PK_TabCabeloEstado
            primary key,
    Descricao         varchar(100) not null
);

create table dbo.TabCabeloNatureza
(
    TabCabeloNaturezaId int          not null
        constraint PK_TabCabeloNatureza
            primary key,
    Descricao           varchar(100) not null
);

create table dbo.TabCabeloTipo
(
    TabCabeloTipoId int          not null
        constraint PK_TabCabeloTipo
            primary key,
    Descricao       varchar(100) not null
);

create table dbo.TabCadItemPorUnidade
(
    CodigoTabCadItemPorUnidade nvarchar(50) not null
        constraint PK_TabCadItemPorUnidade
            primary key
);

create table dbo.TabCaixaFechamentoOperacao
(
    CodigoTabCaixaFechamentoOperacao int not null
        constraint PK_TabCaixaFechamentoOperacao
            primary key,
    Descricao                        nvarchar(20)
);

create table dbo.TabCartaoCredito
(
    CodigoTabCartaoCredito    int           not null
        constraint PK_TabCartaoCredito
            primary key,
    Nome                      nvarchar(20)  not null,
    Logotipo                  nvarchar(255) not null,
    DataInicio                datetime      not null,
    DataFim                   datetime,
    VersaoUpdate              nvarchar(10)  not null,
    CodigoNFBandeiraOperadora nvarchar(2)   not null
);

create table dbo.TabCartaoOperacao
(
    CodigoTabCartaoOperacao int          not null
        constraint PK_TabCartaoOperacao
            primary key,
    Descricao               nvarchar(50) not null,
    Ativo                   bit          not null
);

create table dbo.TabCartaoOperadora
(
    CodigoTabCartaoOperadora int          not null
        constraint PK_TabCartaoOperadora
            primary key,
    Descricao                nvarchar(50) not null,
    Ativo                    bit          not null
);

create table dbo.CadEmpresaCartao
(
    CadEmpresaId             int not null
        constraint FK_CadEmpresaCartao_CadEmpresa
            references dbo.CadEmpresa,
    CodigoTabCartaoOperadora int not null
        constraint FK_CadEmpresaCartao_TabCartaoOperadora
            references dbo.TabCartaoOperadora,
    CodigoTabCartaoOperacao  int not null
        constraint FK_CadEmpresaCartao_TabCartaoOperacao
            references dbo.TabCartaoOperacao,
    CodigoTabCartaoCredito   int not null
        constraint FK_CadEmpresaCartao_TabCartaoCredito
            references dbo.TabCartaoCredito,
    Taxa                     decimal(18, 2),
    TaxaAntecipacao          decimal(18, 2),
    QtdDiasCompensar         int,
    Ativo                    bit,
    DataCadastro             datetime,
    constraint PK_CadEmpresaCartao
        primary key (CadEmpresaId, CodigoTabCartaoOperadora, CodigoTabCartaoOperacao, CodigoTabCartaoCredito)
);

create index IX_FK_CadEmpresaCartao_TabCartaoCredito
    on dbo.CadEmpresaCartao (CodigoTabCartaoCredito);

create index IX_FK_CadEmpresaCartao_TabCartaoOperacao
    on dbo.CadEmpresaCartao (CodigoTabCartaoOperacao);

create index IX_FK_CadEmpresaCartao_TabCartaoOperadora
    on dbo.CadEmpresaCartao (CodigoTabCartaoOperadora);

create table dbo.TabCarteiraCobranca
(
    CodigoTabCarteiraCobranca nvarchar(50) not null
        constraint PK_TabCarteiraCobranca
            primary key
);

create table dbo.TabCategoriaTipo
(
    CodigoTabCategoriaTipo int          not null
        constraint PK_TabCategoriaTipo
            primary key,
    Nome                   nvarchar(20) not null,
    DataInicio             datetime     not null,
    DataFim                datetime,
    VersaoUpdate           nvarchar(10) not null
);

create table dbo.TabCategoriaPadrao
(
    CodigoTabCategoriaId   int          not null
        constraint PK_TabCategoriaPadrao
            primary key,
    Nome                   nvarchar(50) not null,
    CodigoTabCategoriaTipo int
        constraint FK_TabCategoriaPadrao_TabCategoriaTipo
            references dbo.TabCategoriaTipo,
    CodigoPlanoReferencial nvarchar(60)
);

create index IX_FK_TabCategoriaPadrao_TabCategoriaTipo
    on dbo.TabCategoriaPadrao (CodigoTabCategoriaTipo);

create table dbo.TabComissaoGrupo
(
    TabComissaoGrupoId int         not null
        constraint PK_TabComissaoGrupo
            primary key,
    Descricao          varchar(50) not null,
    Grupo              varchar(50) not null,
    DebitoCredito      varchar     not null
);

create table dbo.TabContaPadrao
(
    CodigoTabContaPadrao nvarchar(60) not null
        constraint PK_TabContaPadrao
            primary key
);

create table dbo.TabCstCofins
(
    CodigoTabCstCofins nchar(2)      not null
        constraint PK_TabCstCofins
            primary key,
    Descricao          nvarchar(255) not null,
    DataInicio         datetime      not null,
    DataFim            datetime,
    VersaoUpdate       nvarchar(10)  not null
);

create table dbo.TabCstIcmsCsosn
(
    CodigoTabCstIcmsCsosn nchar(3)      not null
        constraint PK_TabCstIcmsCsosn
            primary key,
    Descricao             nvarchar(500) not null,
    SimplesNacional       bit           not null,
    DataInicio            datetime      not null,
    DataFim               datetime,
    VersaoUpdate          nvarchar(10)  not null
);

create table dbo.TabCstIpi
(
    CodigoTabCstIpi nchar(2)     not null
        constraint PK_TabCstIpi
            primary key,
    Descricao       nvarchar(60) not null,
    DataInicio      datetime     not null,
    DataFim         datetime,
    VersaoUpdate    nvarchar(10) not null
);

create table dbo.TabCstPis
(
    CodigoTabCstPis nchar(2)      not null
        constraint PK_TabCstPis
            primary key,
    Descricao       nvarchar(255) not null,
    DataInicio      datetime      not null,
    DataFim         datetime,
    VersaoUpdate    nvarchar(10)  not null
);

create table dbo.TabDiaSemana
(
    TabDiaSemanaId int identity
        constraint PK_TabDiaSemana
        primary key,
    Descricao      nvarchar(20) not null
);

create table dbo.CadPacotePrecoDiferenciado
(
    CadPacoteId       int            not null
        constraint FK_CadPacotePrecoDiferenciado_CadPacote
            references dbo.CadPacote,
    CadEmpresaId      int            not null
        constraint FK_CadPacotePrecoDiferenciado_CadEmpresa
            references dbo.CadEmpresa,
    TabDiaSemanaId    int            not null
        constraint FK_CadPacotePrecoDiferenciado_TabDiaSemana
            references dbo.TabDiaSemana,
    ValorDiferenciado decimal(18, 2) not null,
    HorarioInicial    time           not null,
    HorarioFinal      time           not null,
    constraint PK_CadPacotePrecoDiferenciado
        primary key (CadPacoteId, CadEmpresaId, TabDiaSemanaId)
);

create index IX_FK_CadPacotePrecoDiferenciado_CadEmpresa
    on dbo.CadPacotePrecoDiferenciado (CadEmpresaId);

create index IX_FK_CadPacotePrecoDiferenciado_TabDiaSemana
    on dbo.CadPacotePrecoDiferenciado (TabDiaSemanaId);

create table dbo.TabEmitenteServico
(
    CodigoTabEmitenteServico int not null
        constraint PK_TabEmitenteServico
            primary key,
    Descricao                nvarchar(50)
);

create table dbo.TabEnquadIPI
(
    CodigoTabEnquadIPI nvarchar(5)   not null
        constraint PK_TabEnquadIPI
            primary key,
    Descricao          nvarchar(255) not null,
    DataInicio         datetime      not null,
    DataFim            datetime,
    VersaoUpdate       nvarchar(10)  not null
);

create table dbo.TabFormaComissao
(
    TabFormaComissaoId int          not null
        constraint PK_TabFormaComissao
            primary key,
    Descricao          nvarchar(20) not null
);

create table dbo.TabFormaPagamento
(
    CodigoTabFormaPagamento int          not null
        constraint PK_TabFormaPagamento
            primary key,
    Descricao               nvarchar(50) not null,
    NomeIcone               nvarchar(20),
    CodigoFormaPagamentoNFe nvarchar(3)
);

create table dbo.TabFuncao
(
    CodigoTabFuncao int identity
        constraint PK_TabFuncao
        primary key,
    Funcao          nvarchar(50) not null,
    NumeroCBO       nvarchar(10),
    Profissional    bit
);

create table dbo.TabGeneroItem
(
    CodigoTabGeneroItem nchar(2)      not null
        constraint PK_TabGeneroItem
            primary key,
    Descricao           nvarchar(500) not null,
    DataInicio          datetime      not null,
    DataFim             datetime,
    VersaoUpdate        nvarchar(10)  not null
);

create table dbo.TabGrauInstrucao
(
    CodigoTabGrauInstrucaoId int           not null
        constraint PK_TabGrauInstrucao
            primary key,
    Descricao                nvarchar(100) not null
);

create table dbo.TabGrauParentesco
(
    CodigoTabGrauParentesco int           not null
        constraint PK_TabGrauParentesco
            primary key,
    Descricao               nvarchar(300) not null
);

create table dbo.TabGrupoOperacao
(
    CodigoGrupoOperacao nvarchar(50) not null
        constraint PK_TabGrupoOperacao
            primary key
);

create table dbo.TabIndEmitente
(
    CodigoTabIndEmitente nchar        not null
        constraint PK_TabIndEmitente
            primary key,
    Descricao            nvarchar(50) not null,
    DataInicio           datetime     not null,
    DataFim              datetime,
    VersaoUpdate         nvarchar(10) not null
);

create table dbo.TabIndFrete
(
    CodigoTabIndFrete nchar        not null
        constraint PK_TabIndFrete
            primary key,
    Descricao         nvarchar(50) not null,
    DataInicio        datetime     not null,
    DataFim           datetime,
    VersaoUpdate      nvarchar(10) not null
);

create table dbo.TabIndICMSMedic
(
    CodigoTabIndICMSMedic int           not null
        constraint PK_TabIndICMSMedic
            primary key,
    Descricao             nvarchar(100) not null,
    DataInicio            datetime      not null,
    DataFim               datetime,
    VersaoUpdate          nvarchar(10)  not null
);

create table dbo.TabIndOperacao
(
    CodigoTabIndOperacao nchar        not null
        constraint PK_TabIndOperacao
            primary key,
    Descricao            nvarchar(50) not null,
    DataInicio           datetime     not null,
    DataFim              datetime,
    VersaoUpdate         nvarchar(10) not null
);

create table dbo.TabIndOrigemProcesso
(
    CodigoTabIndOrigemProcesso nchar        not null
        constraint PK_TabIndOrigemProcesso
            primary key,
    Descricao                  nvarchar(20) not null,
    DataInicio                 datetime     not null,
    DataFim                    datetime,
    VersaoUpdate               nvarchar(10) not null
);

create table dbo.TabIndPagamento
(
    CodigoTabIndPagamento nchar        not null
        constraint PK_TabIndPagamento
            primary key,
    Descricao             nvarchar(20) not null,
    DataInicio            datetime     not null,
    DataFim               datetime,
    VersaoUpdate          nvarchar(10) not null
);

create table dbo.TabIndPerApuracaoIPI
(
    CodigoTabIndPerApuracaoIPI nchar        not null
        constraint PK_TabIndPerApuracaoIPI
            primary key,
    Descricao                  nvarchar(20) not null,
    DataInicio                 datetime     not null,
    DataFim                    datetime,
    VersaoUpdate               nvarchar(10) not null
);

create table dbo.TabItemGrupo
(
    CodigoTabItemGrupoId int not null
        constraint PK_TabItemGrupo
            primary key,
    Descricao            nvarchar(100),
    Segmento             nvarchar(20)
);

create table dbo.TabItemSubGrupo
(
    CodigoTabItemSubGrupoId int not null
        constraint PK_TabItemSubGrupo
            primary key,
    CodigoTabItemGrupoId    int
        constraint FK_TabItemSubGrupo_TabItemGrupo
            references dbo.TabItemGrupo,
    Descricao               nvarchar(50)
);

create index IX_FK_TabItemSubGrupo_TabItemGrupo
    on dbo.TabItemSubGrupo (CodigoTabItemGrupoId);

create table dbo.TabModDocArrecadacao
(
    CodigoTabModDocArrecadacao nchar        not null
        constraint PK_TabModDocArrecadacao
            primary key,
    Descricao                  nvarchar(50) not null,
    DataInicio                 datetime     not null,
    DataFim                    datetime,
    VersaoUpdate               nvarchar(10) not null
);

create table dbo.TabModDocumento
(
    CodigoTabModDocumento nchar(2)      not null
        constraint PK_TabModDocumento
            primary key,
    Descricao             nvarchar(100) not null,
    DataInicio            datetime      not null,
    DataFim               datetime,
    VersaoUpdate          nvarchar(10)  not null
);

create table dbo.TabModalidadeBCICM
(
    CodigoTabModalidadeBCICMS int          not null
        constraint PK_TabModalidadeBCICM
            primary key,
    Descricao                 nvarchar(50) not null,
    DataInicio                datetime     not null,
    DataFim                   datetime,
    VersaoUpdate              nvarchar(10) not null
);

create table dbo.TabModalidadeBCICMSST
(
    CodigoTabModalidadeBCICMSST int          not null
        constraint PK_TabModalidadeBCICMSST
            primary key,
    Descricao                   nvarchar(50) not null,
    DataInicio                  datetime     not null,
    DataFim                     datetime,
    VersaoUpdate                nvarchar(10) not null
);

create table dbo.TabModalidadeConta
(
    CodigoTabModalidadeConta int          not null
        constraint PK_TabModalidadeConta
            primary key,
    Descricao                nvarchar(20) not null
);

create table dbo.TabMotivoDesoneracao
(
    CodigoTabMotivoDesoneracao int           not null
        constraint PK_TabMotivoDesoneracao
            primary key,
    Descricao                  nvarchar(255) not null,
    DataInicio                 datetime      not null,
    DataFim                    datetime,
    VersaoUpdate               nvarchar(10)  not null
);

create table dbo.TabMotivoMovimentacaoEstoque
(
    TabMotivoMovimentacaoEstoqueId int identity
        constraint PK_TabMotivoMovimentacaoEstoque
        primary key,
    Descricao                      nvarchar(50) not null
);

create table dbo.TabMunicipio
(
    CodigoTabMunicipio nchar(7)     not null
        constraint PK_TabMunicipio
            primary key,
    Nome               nvarchar(50) not null,
    DataInicio         datetime     not null,
    DataFim            datetime     not null,
    VersaoUpdate       nvarchar(10) not null
);

create table dbo.TabNCM
(
    CodigoTabNCM nvarchar(8)   not null
        constraint PK_TabNCM
            primary key,
    Descricao    nvarchar(255) not null,
    DataInicio   datetime      not null,
    DataFim      datetime,
    VersaoUpdate nvarchar(10)  not null
);

create table dbo.TabNCMExcecao
(
    CodigoTabNCM  nvarchar(8)    not null
        constraint FK_TabNCMExcecao_TabNCM
            references dbo.TabNCM,
    CodigoExcecao nchar(3)       not null,
    Descricao     nvarchar(255)  not null,
    Tributado     bit            not null,
    Aliquota      decimal(18, 2) not null,
    DataInicio    datetime       not null,
    DataFim       datetime,
    VersaoUpdate  nvarchar(10)   not null,
    Updated    datetime       not null,
    constraint PK_TabNCMExcecao
        primary key (CodigoTabNCM, CodigoExcecao)
);

create table dbo.TabNcmCest
(
    TabCEST_CodigoTabCEST nvarchar(7) not null
        constraint FK_TabNcmCest_TabCEST
            references dbo.TabCEST,
    TabNCM_CodigoTabNCM   nvarchar(8) not null
        constraint FK_TabNcmCest_TabNCM
            references dbo.TabNCM,
    constraint PK_TabNcmCest
        primary key (TabCEST_CodigoTabCEST, TabNCM_CodigoTabNCM)
);

create index IX_FK_TabNcmCest_TabNCM
    on dbo.TabNcmCest (TabNCM_CodigoTabNCM);

create table dbo.TabOperacaoComCartao
(
    CodigoTabOperacaoComCartaoId  int            not null
        constraint PK_TabOperacaoComCartao
            primary key,
    CodigoTabAdministradoraCartao nvarchar(50)   not null,
    Bandeira                      nvarchar(50)   not null,
    Operacao                      nvarchar(20)   not null,
    Taxa                          decimal(18, 2) not null,
    TaxaAntecipacao               decimal(18, 2) not null,
    QtdDiasCompensar              int            not null,
    Ativo                         bit            not null,
    DataCadastro                  datetime       not null
);

create table dbo.TabOrigemMercadoria
(
    CodigoTabOrigemMercadoria int           not null
        constraint PK_TabOrigemMercadoria
            primary key,
    Descricao                 nvarchar(255) not null,
    DataInicio                datetime      not null,
    DataFim                   datetime,
    VersaoUpdate              nvarchar(10)  not null
);

create table dbo.TabPagtoAntecipaAtrasa
(
    CodigoTabPagtoAntecipaAtrasa nchar        not null
        constraint PK_TabPagtoAntecipaAtrasa
            primary key,
    Descricao                    nvarchar(20) not null,
    DataInicio                   datetime     not null,
    DataFim                      datetime,
    VersaoUpdate                 nvarchar(10) not null
);

create table dbo.TabPais
(
    CodigoTabPais int          not null
        constraint PK_TabPais
            primary key,
    Nome          nvarchar(50) not null,
    DataInicio    datetime     not null,
    DataFim       datetime,
    VersaoUpdate  nvarchar(10) not null
);

create table dbo.TabPeleEstado
(
    TabPeleEstadoId int          not null
        constraint PK_TabPeleEstado
            primary key,
    Descricao       varchar(100) not null
);

create table dbo.TabPeleTipo
(
    TabPeleTipoId int          not null
        constraint PK_TabPeleTipo
            primary key,
    Descricao     varchar(100) not null
);

create table dbo.TabPeleTonalidade
(
    TabPeleTonalidadeId int          not null
        constraint PK_TabPeleTonalidade
            primary key,
    Descricao           varchar(100) not null
);

create table dbo.TabPerfilPadrao
(
    CodigoTabPerfilPadrao nvarchar(50)  not null
        constraint PK_TabPerfilPadrao
            primary key,
    Descricao             nvarchar(100) not null
);

create table dbo.TabPerfilRotinaEventoPadrao
(
    AppRotinaEvento_CodigoAppRotina       int          not null,
    AppRotinaEvento_CodigoAppEvento       nvarchar(50) not null,
    TabPerfilPadrao_CodigoTabPerfilPadrao nvarchar(50) not null
        constraint FK_TabPerfilRotinaEventoPadrao_TabPerfilPadrao
            references dbo.TabPerfilPadrao,
    constraint PK_TabPerfilRotinaEventoPadrao
        primary key (AppRotinaEvento_CodigoAppRotina, AppRotinaEvento_CodigoAppEvento,
                     TabPerfilPadrao_CodigoTabPerfilPadrao),
    constraint FK_TabPerfilRotinaEventoPadrao_AppRotinaEvento
        foreign key (AppRotinaEvento_CodigoAppRotina, AppRotinaEvento_CodigoAppEvento) references dbo.AppRotinaEvento
);

create index IX_FK_TabPerfilRotinaEventoPadrao_TabPerfilPadrao
    on dbo.TabPerfilRotinaEventoPadrao (TabPerfilPadrao_CodigoTabPerfilPadrao);

create table dbo.TabPrazoEnvio
(
    CodigoTabPrazoEnvio int          not null
        constraint PK_TabPrazoEnvio
            primary key,
    Descricao           nvarchar(20) not null,
    TempoValor          int          not null,
    TempoTipo           nvarchar(10) not null,
    DataInicio          datetime     not null,
    DataFim             datetime     not null,
    VersaoUpdate        nvarchar(10) not null
);

create table dbo.TabPreferencia
(
    PadraoCorHexa nvarchar(7) not null
        constraint PK_TabPreferencia
            primary key,
    SemelhancaCor nvarchar(20),
    Descricao     nvarchar(100)
);

create table dbo.TabRegimeServico
(
    CodigoTabRegimeServicoId int identity
        constraint PK_TabRegimeServico
        primary key,
    Descricao                nvarchar(60) not null
);

create table dbo.TabRegimeTributacao
(
    CodigoTabRegimeTributacaoId int identity
        constraint PK_TabRegimeTributacao
        primary key,
    Descricao                   nvarchar(60) not null
);

create table dbo.TabSeloIPI
(
    CodigoTabSeloIPI nvarchar(6)   not null
        constraint PK_TabSeloIPI
            primary key,
    Descricao        nvarchar(100) not null,
    DataInicio       datetime      not null,
    DataFim          datetime,
    VersaoUpdate     nvarchar(10)  not null
);

create table dbo.TabServicoGrupo
(
    CodigoTabServicoGrupoId int           not null
        constraint PK_TabServicoGrupo
            primary key,
    Descricao               nvarchar(20)  not null,
    Icone                   nvarchar(255) not null,
    Ativo                   bit           not null
);

create table dbo.CadServicoGrupo
(
    CadServicoGrupoId       int identity
        constraint PK_CadServicoGrupo
        primary key,
    Descricao               nvarchar(20) not null,
    CadAssinanteId          int          not null,
    CadEmpresaId            int          not null
        constraint FK_CadServicoGrupo_CadEmpresa
            references dbo.CadEmpresa,
    Icone                   nvarchar(255),
    Ativo                   bit,
    CodigoTabServicoGrupoId int
        constraint FK_CadServicoGrupo_TabServicoGrupo
            references dbo.TabServicoGrupo
);

create index IX_FK_CadServicoGrupo_CadEmpresa
    on dbo.CadServicoGrupo (CadEmpresaId);

create index IX_FK_CadServicoGrupo_TabServicoGrupo
    on dbo.CadServicoGrupo (CodigoTabServicoGrupoId);

create table dbo.TabServico
(
    CodigoTabServico        int not null
        constraint PK_TabServico
            primary key,
    CodigoTabServicoGrupoId int
        constraint FK_TabServico_TabServicoGrupo
            references dbo.TabServicoGrupo,
    Descricao               nvarchar(255),
    Duracao                 time,
    Ativo                   bit not null
);

create index IX_FK_TabServico_TabServicoGrupo
    on dbo.TabServico (CodigoTabServicoGrupoId);

create table dbo.TabServicoLC116
(
    CodigoTabServicoLC116 nvarchar(5)   not null
        constraint PK_TabServicoLC116
            primary key,
    Descricao             nvarchar(500) not null,
    DataInicio            datetime      not null,
    DataFim               datetime      not null,
    VersaoUpdate          nvarchar(10)  not null
);

create table dbo.TabServicoTributacao
(
    CodigoTabServicoTributacao int           not null
        constraint PK_TabServicoTributacao
            primary key,
    Descricao                  nvarchar(100) not null,
    DataInicio                 datetime      not null,
    DataFim                    datetime      not null,
    VersaoUpdate               nvarchar(10)  not null
);

create table dbo.TabServicoTributacaoMunicipal
(
    CodigoTabServicoTributacao int not null
        constraint PK_TabServicoTributacaoMunicipal
            primary key,
    CodigoTabServicoGrupoId    int
        constraint FK_TabServicoTributacaoMunicipal_TabServicoGrupo
            references dbo.TabServicoGrupo,
    CodigoIBGE                 nvarchar(7),
    CodigoTabServico           int
        constraint FK_TabServicoTributacaoMunicipal_TabServico
            references dbo.TabServico,
    CodigoTabServicoLC116      nvarchar(5)
        constraint FK_TabServicoTributacaoMunicipal_TabServicoLC116
            references dbo.TabServicoLC116,
    CodigoMunicipio            nvarchar(20),
    CodigoTabEmitenteServico   int,
    Descricao                  nvarchar(255),
    ISSAliquota                decimal(18, 2),
    ISSRetido                  bit,
    IRRFAliquota               decimal(18, 2),
    IRRFRetido                 bit,
    PISAliquota                decimal(18, 2),
    PISRetido                  bit,
    COFINSAliquota             decimal(18, 2),
    COFINSRetido               bit,
    INSSAliquota               decimal(18, 2),
    INSSRetido                 bit,
    CSLLAliquota               decimal(18, 2),
    CSLLRetido                 bit,
    ValorISSEspecificado       bit,
    Observacao                 nvarchar(255),
    AliquotaFederal            decimal(18, 2)
);

create index IX_FK_TabServicoTributacaoMunicipal_TabServico
    on dbo.TabServicoTributacaoMunicipal (CodigoTabServico);

create index IX_FK_TabServicoTributacaoMunicipal_TabServicoGrupo
    on dbo.TabServicoTributacaoMunicipal (CodigoTabServicoGrupoId);

create index IX_FK_TabServicoTributacaoMunicipal_TabServicoLC116
    on dbo.TabServicoTributacaoMunicipal (CodigoTabServicoLC116);

create table dbo.TabServicoUnidade
(
    CodigoTabServicoUnidade int not null
        constraint PK_TabServicoUnidade
            primary key,
    Descricao               nvarchar(100),
    DataInicio              datetime,
    Datafim                 datetime,
    VersaoUpdate            nvarchar(10)
);

create table dbo.TabSitDocumento
(
    CodigoTabSitDocumento nchar(2)      not null
        constraint PK_TabSitDocumento
            primary key,
    Descricao             nvarchar(100) not null,
    DataInicio            datetime      not null,
    DataFim               datetime,
    VersaoUpdate          nvarchar(10)  not null
);

create table dbo.TabSitDocumentoMigrate
(
    CodigoTabSitDocumentoMigrate nvarchar(3)   not null
        constraint PK_TabSitDocumentoMigrate
            primary key,
    Descricao                    nvarchar(100) not null,
    DataInicio                   datetime      not null,
    DataFim                      datetime,
    VersaoUpdate                 nvarchar(10)  not null
);

create table dbo.TabStatusComanda
(
    CodigoTabStatusComanda int          not null
        constraint PK_TabStatusComanda
            primary key,
    Descricao              nvarchar(50) not null
);

create table dbo.TabStatusPagarReceber
(
    CodigoStatusPagarReceber nvarchar(20) not null
        constraint PK_TabStatusPagarReceber
            primary key
);

create table dbo.TabTema
(
    CodigoTabTema int not null
        constraint PK_TabTema
            primary key,
    CorPrincipal  nvarchar(7),
    CorSecundaria nvarchar(7),
    Descricao     nvarchar(50)
);

create table dbo.CadEmpresaConfiguracao
(
    CadEmpresaId                    int not null
        constraint PK_CadEmpresaConfiguracao
            primary key
        constraint FK_CadEmpresaConfiguracao_CadEmpresa
            references dbo.CadEmpresa,
    AgendaTempoLimite               time,
    AgendaTempoInatividade          int,
    AgendaControleAutomaticoComanda bit,
    CodigoTabTema                   int
        constraint FK_CadEmpresaConfiguracao_TabTema
            references dbo.TabTema,
    FechamentoPorFinanceiro         bit,
    CadastroCompletoObrigatorio     bit,
    URLVideo                        nvarchar(255),
    Autoplay                        bit
);

create index IX_FK_CadEmpresaConfiguracao_TabTema
    on dbo.CadEmpresaConfiguracao (CodigoTabTema);

create table dbo.TabTipoAmbiente
(
    CodigoTabTipoAmbienteId int          not null
        constraint PK_TabTipoAmbiente
            primary key,
    Descricao               nvarchar(50) not null
);

create table dbo.TabTipoBeneficio
(
    CodigoTabTipoBeneficioId int          not null
        constraint PK_TabTipoBeneficio
            primary key,
    Descricao                nvarchar(50) not null
);

create table dbo.TabTipoComissao
(
    TabTipoComissaoId int          not null
        constraint PK_TabTipoComissao
            primary key,
    Descricao         nvarchar(20) not null
);

create table dbo.CadServico
(
    CadServicoId                     int identity
        constraint PK_CadServico
        primary key,
    CadAssinanteId                   int            not null,
    CadEmpresaId                     int            not null
        constraint FK_CAD_CadServico_CAD_CadEmpresa_CadEmpresaId
            references dbo.CadEmpresa,
    Codigo                           nvarchar(20)   not null,
    NomeServico                      nvarchar(100)  not null,
    Descricao                        nvarchar(1000) not null,
    DescricaoResumida                nvarchar(255)  not null,
    CodigoServicoMunicipal           nvarchar(20),
    CodigoTabServicoLC116            nvarchar(5),
    CodigoTabServicoTributacao       int
        constraint FK_CAD_CadServico_SIS_TabServicoTributacao_CodigoTabServicoTributacao
            references dbo.TabServicoTributacao,
    AliquotaISS                      decimal(18, 2) not null,
    PrecoUnitario                    decimal(18, 2) not null,
    CodigoTabServicoUnidade          int
        constraint FK_CadServico_TabServicoUnidade
            references dbo.TabServicoUnidade,
    Duracao                          time           not null,
    CodigoTabPrazoEnvio              int
        constraint FK_CadServico_TabPrazoEnvio
            references dbo.TabPrazoEnvio,
    Mensagem                         nvarchar(1000) not null,
    CadServicoGrupoId                int
        constraint FK_CadServico_CadServicoGrupo
            references dbo.CadServicoGrupo,
    ComissaoProfissional             decimal(18, 6) not null,
    AgendamentoOnLine                bit            not null,
    PossibilidadeEncaixe             bit            not null,
    PrecoDiferenciado                bit            not null,
    TabHabilidadePrecoDiferenciadoId int,
    TabFormaComissaoId               int
        constraint FK_CadServico_TabFormaComissao
            references dbo.TabFormaComissao,
    TabTipoComissaoId                int
        constraint FK_CadServico_TabTipoComissao
            references dbo.TabTipoComissao,
    Comissao                         decimal(18, 2) not null,
    EnviarMsgAposdia                 int            not null,
    MsgPosVenda                      nvarchar(500)  not null,
    EnviarMsgAposdiaApp              int            not null,
    EnviarFotoUltimoServico          bit            not null,
    SugerirAgendaAutomatica          bit            not null,
    EnviarEmail                      bit            not null,
    MsgCliente                       nvarchar(500)  not null,
    CodigoTabServico                 int
        constraint FK_CadServico_TabServico
            references dbo.TabServico,
    ValorRateio                      decimal(18, 2) not null,
    ValorCusto                       decimal(18, 2) not null,
    Ativo                            bit,
    TabTipoComissaoIdAssistente      int
        constraint FK_CadServico_TabTipoComissao1
            references dbo.TabTipoComissao,
    ValorComissaoAssistente          decimal(18, 2),
    LucroValor                       decimal(18, 2) not null,
    LucroPercentual                  decimal(5, 2)  not null,
    LucroLiquido                     decimal        not null,
    PrevisaoRetorno                  int            not null,
    DespesaValor                     decimal(18, 2) not null,
    Created                       datetime       not null,
    UserCreate                       nvarchar(128)  not null,
    Updated                       datetime       not null,
    UserUpdate                       nvarchar(128)  not null
);

create index IX_FK_CAD_CadServico_CAD_CadEmpresa_CadEmpresaId
    on dbo.CadServico (CadEmpresaId);

create index IX_FK_CAD_CadServico_SIS_TabServicoTributacao_CodigoTabServicoTributacao
    on dbo.CadServico (CodigoTabServicoTributacao);

create index IX_FK_CadServico_CadServicoGrupo
    on dbo.CadServico (CadServicoGrupoId);

create index IX_FK_CadServico_TabFormaComissao
    on dbo.CadServico (TabFormaComissaoId);

create index IX_FK_CadServico_TabPrazoEnvio
    on dbo.CadServico (CodigoTabPrazoEnvio);

create index IX_FK_CadServico_TabServico
    on dbo.CadServico (CodigoTabServico);

create index IX_FK_CadServico_TabServicoUnidade
    on dbo.CadServico (CodigoTabServicoUnidade);

create index IX_FK_CadServico_TabTipoComissao
    on dbo.CadServico (TabTipoComissaoId);

create index IX_FK_CadServico_TabTipoComissao1
    on dbo.CadServico (TabTipoComissaoIdAssistente);

create table dbo.CadServicoPrecoDiferenciado
(
    CadServicoId      int            not null
        constraint FK_CadServicoPrecoDiferenciado_CadServico
            references dbo.CadServico,
    CadEmpresaId      int            not null
        constraint FK_CadServicoPrecoDiferenciado_CadEmpresa
            references dbo.CadEmpresa,
    TabDiaSemanaId    int            not null
        constraint FK_TabHabilidadePrecoDiferenciado_TabDiaSemana
            references dbo.TabDiaSemana,
    ValorDiferenciado decimal(18, 2) not null,
    HorarioInicial    time           not null,
    HorarioFinal      time           not null,
    constraint PK_CadServicoPrecoDiferenciado
        primary key (CadServicoId, CadEmpresaId, TabDiaSemanaId)
);

create index IX_FK_CadServicoPrecoDiferenciado_CadEmpresa
    on dbo.CadServicoPrecoDiferenciado (CadEmpresaId);

create index IX_FK_TabHabilidadePrecoDiferenciado_TabDiaSemana
    on dbo.CadServicoPrecoDiferenciado (TabDiaSemanaId);

create table dbo.TabTipoConta
(
    CodigoTabTipoConta int           not null
        constraint PK_TabTipoConta
            primary key,
    Nome               nvarchar(50)  not null,
    Descricao          nvarchar(100) not null,
    Logotipo           nvarchar(255) not null,
    DataInicio         datetime      not null,
    DataFim            datetime,
    VersaoUpdate       nvarchar(10)  not null
);

create table dbo.TabTipoContribuinteICMS
(
    CodigoTabTipoContribuinteICMS int          not null
        constraint PK_TabTipoContribuinteICMS
            primary key,
    Descricao                     nvarchar(50) not null,
    DataInicio                    datetime     not null,
    DataFim                       datetime,
    VersaoUpdate                  nvarchar(10) not null,
    Updated                    datetime     not null
);

create table dbo.TabTipoDescontoComissaoAssistente
(
    CodigoTabTipoDescontoComissaoAssistente int          not null
        constraint PK_TabTipoDescontoComissaoAssistente
            primary key,
    Descricao                               nvarchar(50) not null
);

create table dbo.TabTipoDocImportacao
(
    CodigoTabTipoDocImportacao int          not null
        constraint PK_TabTipoDocImportacao
            primary key,
    Descricao                  nvarchar(50) not null,
    DataInicio                 datetime     not null,
    DataFim                    datetime,
    VersaoUpdate               nvarchar(10) not null
);

create table dbo.TabTipoDocTitulo
(
    CodigoTabTipoDocTitulo int          not null
        constraint PK_TabTipoDocTitulo
            primary key,
    CadAssinanteId         int          not null,
    CadEmpresaId           int          not null,
    Nome                   nvarchar(50) not null,
    DataInicio             datetime     not null,
    DataFim                datetime     not null,
    VersaoUpdate           nvarchar(10) not null
);

create table dbo.TabTipoEndereco
(
    CodigoTabTipoEndereco int          not null
        constraint PK_TabTipoEndereco
            primary key,
    Descricao             nvarchar(20) not null,
    DataInicio            datetime     not null,
    DataFim               datetime     not null,
    VersaoUpdate          nvarchar(10) not null
);

create table dbo.TabTipoEstabelecimento
(
    CodigoTipoEstabelecimento nvarchar(20) not null
        constraint PK_TabTipoEstabelecimento
            primary key
);

create table dbo.TabTipoEstadoCivil
(
    CodigoTabTipoEstadoCivilId int identity
        constraint PK_TabTipoEstadoCivil
        primary key,
    Descricao                  nvarchar(20) not null
);

create table dbo.TabTipoEventoNFe
(
    CodigoTabTipoEventoNFe int          not null
        constraint PK_TabTipoEventoNFe
            primary key,
    Descricao              nvarchar(30) not null
);

create table dbo.TabTipoGeraNFOperacao
(
    CodigoTabTipoGeraNFOperacaoId int identity
        constraint PK_TabTipoGeraNFOperacao
        primary key,
    Descricao                     nvarchar(50) not null
);

create table dbo.TabTipoGeracaoNota
(
    TabTipoGeracaoNotaId int         not null
        constraint PK_TabTipoGeracaoNota
            primary key,
    Descricao            varchar(50) not null
);

create table dbo.CadEmpresaDadosFiscais
(
    CadEmpresaId                  int           not null
        constraint PK_CadEmpresaDadosFiscais
            primary key
        constraint FK_CadEmpresaDadosFiscais_CadEmpresa
            references dbo.CadEmpresa,
    CodigoTabTipoGeraNFOperacaoId int           not null
        constraint FK_CadEmpresaDadosFiscais_TabTipoGeraNFOperacao
            references dbo.TabTipoGeraNFOperacao,
    IdentificacaoCSC              nvarchar(6)   not null,
    CodigoNFCe                    nvarchar(36)  not null,
    CodigoTabRegimeTributacaoId   int           not null
        constraint FK_CadEmpresaDadosFiscais_TabRegimeTributacao
            references dbo.TabRegimeTributacao,
    CodigoTabRegimeServicoId      int           not null
        constraint FK_CadEmpresaDadosFiscais_TabRegimeServico
            references dbo.TabRegimeServico,
    InscricaoEstadual             nvarchar(20)  not null,
    InscricaoMunicipal            nvarchar(20)  not null,
    PossuiEmpresaAdm              bit           not null,
    PossuiEmpresaComercio         bit           not null,
    NFCeSerie                     nvarchar(3)   not null,
    NFCeNumero                    bigint        not null,
    NFCeAmbiente                  int           not null
        constraint FK_CadEmpresaDadosFiscais_TabTipoAmbiente
            references dbo.TabTipoAmbiente,
    NFeSerie                      nvarchar(3)   not null,
    NFeNumero                     bigint        not null,
    NFeAmbiente                   int           not null
        constraint FK_CadEmpresaDadosFiscais_TabTipoAmbiente1
            references dbo.TabTipoAmbiente,
    CertificadoPath               nvarchar(255) not null,
    CertificadoSenha              nvarchar(50)  not null,
    CertificadoDataVencimento     datetime      not null,
    TokenEmissao                  nvarchar(255) not null,
    ProximoNumeroRPS              int,
    SerieRPS                      nvarchar(10),
    AliquotaISS                   decimal(18, 2),
    AliquotaISSRetido             decimal(18, 2),
    UsuarioAutent                 nvarchar(20),
    SenhaAutent                   nvarchar(20),
    CodigoEmpresaInvoiCY          nvarchar(255),
    ChaveEmpresaHomologaInvoiCY   nvarchar(255),
    ChaveEmpresaProducaoInvoiCY   nvarchar(255),
    TabTipoGeracaoNotaId          int
        constraint FK_CadEmpresaDadosFiscais_TabTipoGeracaoNota
            references dbo.TabTipoGeracaoNota
);

create index IX_FK_CadEmpresaDadosFiscais_TabRegimeServico
    on dbo.CadEmpresaDadosFiscais (CodigoTabRegimeServicoId);

create index IX_FK_CadEmpresaDadosFiscais_TabRegimeTributacao
    on dbo.CadEmpresaDadosFiscais (CodigoTabRegimeTributacaoId);

create index IX_FK_CadEmpresaDadosFiscais_TabTipoAmbiente
    on dbo.CadEmpresaDadosFiscais (NFCeAmbiente);

create index IX_FK_CadEmpresaDadosFiscais_TabTipoAmbiente1
    on dbo.CadEmpresaDadosFiscais (NFeAmbiente);

create index IX_FK_CadEmpresaDadosFiscais_TabTipoGeracaoNota
    on dbo.CadEmpresaDadosFiscais (TabTipoGeracaoNotaId);

create index IX_FK_CadEmpresaDadosFiscais_TabTipoGeraNFOperacao
    on dbo.CadEmpresaDadosFiscais (CodigoTabTipoGeraNFOperacaoId);

create table dbo.TabTipoItem
(
    CodigoTabTipoItem int           not null
        constraint PK_TabTipoItem
            primary key,
    Descricao         nvarchar(100) not null,
    DataInicio        datetime      not null,
    DataFim           datetime,
    VersaoUpdate      nvarchar(10)  not null,
    DataUpdate        datetime
);

create table dbo.TabTipoMedic
(
    CodigoTabTipoMedic int          not null
        constraint PK_TabTipoMedic
            primary key,
    Descricao          nvarchar(50) not null,
    DataInicio         datetime     not null,
    DataFim            datetime,
    VersaoUpdate       nvarchar(10) not null
);

create table dbo.TabTipoModalidadeBoleto
(
    CodigoTabTipoModalidadeBoleto nvarchar(20) not null
        constraint PK_TabTipoModalidadeBoleto
            primary key
);

create table dbo.TabTipoMovimentacaoEstoque
(
    TabTipoMovimentacaoEstoqueId nvarchar(50) not null
        constraint PK_TabTipoMovimentacaoEstoque
            primary key,
    Descricao                    nvarchar(50)
);

create table dbo.TabTipoOperacao
(
    CodigoTipoOperacao nvarchar(20) not null
        constraint PK_TabTipoOperacao
            primary key
);

create table dbo.TabTipoParticipante
(
    CodigoTabTipoParticipante nvarchar(20) not null
        constraint PK_TabTipoParticipante
            primary key
);

create table dbo.TabTipoPeriodo
(
    TabTipoPeriodoId int identity
        constraint PK_TabTipoPeriodo
        primary key,
    Descricao        nvarchar(20) not null
);

create table dbo.CadEmpresaHorario
(
    CadEmpresaId     int not null
        constraint FK_CadEmpresaHorario_CadEmpresa
            references dbo.CadEmpresa,
    TabDiaSemanaId   int not null
        constraint FK_CadEmpresaHorario_TabDiaSemana
            references dbo.TabDiaSemana,
    TabTipoPeriodoId int not null
        constraint FK_CadEmpresaHorario_TabTipoPeriodo
            references dbo.TabTipoPeriodo,
    HorarioEntrada   time,
    HorarioSaida     time,
    constraint PK_CadEmpresaHorario
        primary key (CadEmpresaId, TabDiaSemanaId, TabTipoPeriodoId)
);

create index IX_FK_CadEmpresaHorario_TabDiaSemana
    on dbo.CadEmpresaHorario (TabDiaSemanaId);

create index IX_FK_CadEmpresaHorario_TabTipoPeriodo
    on dbo.CadEmpresaHorario (TabTipoPeriodoId);

create table dbo.TabTipoPersonalidade
(
    CodigoTabTipoPersonalidade int          not null
        constraint PK_TabTipoPersonalidade
            primary key,
    Descricao                  nvarchar(20) not null,
    DataInicio                 datetime     not null,
    DataFim                    datetime,
    VersaoUpdate               nvarchar(10) not null
);

create table dbo.TabTipoPlanoContaGrupo
(
    CodigoTabTipoPlanoContaGrupo int           not null
        constraint PK_TabTipoPlanoContaGrupo
            primary key,
    Nome                         nvarchar(50)  not null,
    Descricao                    nvarchar(100) not null,
    Logotipo                     nvarchar(255) not null,
    DataInicio                   datetime      not null,
    DataFim                      datetime,
    VersaoUpdate                 nvarchar(10)  not null
);

create table dbo.CadPlanoContaDetalhe
(
    CadPlanoContaDetalheId       int identity
        constraint PK_CadPlanoContaDetalhe
        primary key,
    CadPlanoContaId              int           not null
        constraint FK_CadPlanoContaDetalhe_CadPlanoConta
            references dbo.CadPlanoConta,
    Classificador                nvarchar(60)  not null,
    CodigoPlanoReferencial       nvarchar(60)  not null,
    Nivel                        int           not null,
    NomeConta                    nvarchar(150) not null,
    CadPlanoContaDetalhePaiId    int,
    CodigoTabTipoPlanoContaGrupo int           not null
        constraint FK_CadPlanoContaDetalhe_TabTipoPlanoContaGrupo
            references dbo.TabTipoPlanoContaGrupo,
    CodigoTabContaPadrao         nvarchar(60),
    ContaOculta                  bit,
    Sistema                      bit           not null,
    Analitico                    bit           not null
);

create index IX_FK_CadPlanoContaDetalhe_CadPlanoConta
    on dbo.CadPlanoContaDetalhe (CadPlanoContaId);

create index IX_FK_CadPlanoContaDetalhe_TabTipoPlanoContaGrupo
    on dbo.CadPlanoContaDetalhe (CodigoTabTipoPlanoContaGrupo);

create table dbo.TabPlanoContaReferencial
(
    CadPlanoContaDetalheId       int           not null
        constraint PK_TabPlanoContaReferencial
            primary key,
    Classificador                nvarchar(60)  not null,
    CodigoPlanoReferencial       nvarchar(60)  not null,
    Nivel                        int           not null,
    NomeConta                    nvarchar(150) not null,
    CadPlanoContaDetalhePaiId    int           not null,
    CodigoTabTipoPlanoContaGrupo int           not null
        constraint FK_TabPlanoContaReferencial_TabTipoPlanoContaGrupo
            references dbo.TabTipoPlanoContaGrupo,
    CodigoTabContaPadrao         nvarchar(60),
    ContaOculta                  bit           not null,
    Sistema                      bit           not null,
    Analitico                    bit           not null
);

create index IX_FK_TabPlanoContaReferencial_TabTipoPlanoContaGrupo
    on dbo.TabPlanoContaReferencial (CodigoTabTipoPlanoContaGrupo);

create table dbo.TabTipoRemessa
(
    CodigoTabTipoRemessa nvarchar(20) not null
        constraint PK_TabTipoRemessa
            primary key
);

create table dbo.ContaCorrente
(
    ContaCorrenteId               int identity
        constraint PK_ContaCorrente
        primary key,
    CadAssinanteId                int          not null,
    CadEmpresaId                  int          not null
        constraint FK_ContaCorrente_CadEmpresa
            references dbo.CadEmpresa,
    CodigoTabTipoConta            int          not null
        constraint FK_ContaCorrente_TabTipoConta
            references dbo.TabTipoConta,
    Nome                          nvarchar(50) not null,
    CodigoTabBanco                int
        constraint FK_CAD_CadContaCorrente_SIS_TabBanco_CodigoTabBanco
            references dbo.TabBanco,
    CodigoTabCartaoCredito        int
        constraint FK_ContaCorrente_TabCartaoCredito
            references dbo.TabCartaoCredito,
    Agencia                       nvarchar(10),
    ContaNumero                   nvarchar(20),
    LimiteCredito                 decimal(18, 2),
    SaldoInicial                  decimal(18, 2),
    Encerrada                     bit,
    Validade                      nvarchar(5),
    DiaVencimento                 int,
    CadPlanoContaDetalheId        int
        constraint FK_ContaCorrente_CadPlanoContaDetalhe
            references dbo.CadPlanoContaDetalhe,
    BloqueiaEdicao                bit,
    CodigoTabCarteiraCobranca     nvarchar(50)
        constraint FK_ContaCorrente_TabCarteiraCobranca
            references dbo.TabCarteiraCobranca,
    CodigoTabTipoRemessa          nvarchar(20)
        constraint FK_ContaCorrente_TabTipoRemessa
            references dbo.TabTipoRemessa,
    CodigoTabTipoModalidadeBoleto nvarchar(20)
        constraint FK_ContaCorrente_TabTipoModalidadeBoleto
            references dbo.TabTipoModalidadeBoleto,
    Convenio                      nvarchar(50),
    VariacaoCarteira              nvarchar(50),
    Instrucao                     nvarchar(1000),
    Contrato                      nvarchar(50),
    CodigoCedente                 nvarchar(20),
    CodigoTransmissao             nvarchar(50),
    ValorJuros                    decimal(18, 2),
    ValorDesconto                 decimal(18, 2),
    ValorMulta                    decimal(18, 2),
    ValorAbatimento               decimal(18, 2),
    DiasParaBaixa                 int,
    DiasParaProtesto              int,
    DigitoAgencia                 nvarchar(2),
    DigitoContaCorrente           nvarchar(2),
    UltimoNossoNumero             int,
    NumeroRemessa                 int,
    Ativo                         bit,
    ContaPrincipal                bit,
    CodigoTabModalidadeConta      int
        constraint FK_ContaCorrente_TabModalidadeConta
            references dbo.TabModalidadeConta,
    ImportacaoAutomaticaExtrato   bit,
    DataSaldoInicial              datetime,
    NumeroCartaoCreditoDebito     nvarchar(16),
    ValidadeCartao                nvarchar(7),
    DiaFechamentoCartao           int,
    DiaPagamentoCartao            int,
    ContaGerencial                bit
);

create table dbo.Boleto
(
    BoletoId              bigint identity
        constraint PK_Boleto
        primary key,
    CadAssinanteId        int          not null,
    CadEmpresaId          int          not null,
    ContaCorrenteId       int          not null
        constraint FK_Boleto_ContaCorrente
            references dbo.ContaCorrente,
    ContaReceberId        int          not null,
    DataEmissao           datetime     not null,
    DataVencimento        datetime     not null,
    DataPagamento         datetime,
    NossoNumero           nvarchar(20) not null,
    Situacao              nvarchar(20) not null,
    DataRecebimento       datetime,
    Impresso              bit          not null,
    Remessa               bit          not null,
    Email                 bit          not null,
    ConfiguracaoBoletoId  int,
    ValorTotalOriginal    decimal(18, 2),
    ValorTotalRecebimento decimal(18, 2),
    ValorJuros            decimal(18, 2),
    ValorMulta            decimal(18, 2),
    ValorDesconto         decimal(18, 2)
);

create index IX_FK_Boleto_ContaCorrente
    on dbo.Boleto (ContaCorrenteId);

create table dbo.BoletoRemessa
(
    NumeroRemessa      int            not null,
    ContaCorrenteId    int            not null
        constraint FK_BoletoRemessa_ContaCorrente
            references dbo.ContaCorrente,
    CadAssinanteId     int            not null,
    CadEmpresaId       int            not null,
    DataHora           datetime       not null,
    Total              int            not null,
    NossoNumeroInicial nvarchar(20)   not null,
    NossoNumeroFinal   nvarchar(20)   not null,
    NomeArquivo        nvarchar(1000) not null,
    constraint PK_BoletoRemessa
        primary key (NumeroRemessa, ContaCorrenteId)
);

create index IX_FK_BoletoRemessa_ContaCorrente
    on dbo.BoletoRemessa (ContaCorrenteId);

create index IX_FK_ContaCorrente_CadEmpresa
    on dbo.ContaCorrente (CadEmpresaId);

create index IX_FK_ContaCorrente_CadPlanoContaDetalhe
    on dbo.ContaCorrente (CadPlanoContaDetalheId);

create index IX_FK_CAD_CadContaCorrente_SIS_TabBanco_CodigoTabBanco
    on dbo.ContaCorrente (CodigoTabBanco);

create index IX_FK_ContaCorrente_TabCartaoCredito
    on dbo.ContaCorrente (CodigoTabCartaoCredito);

create index IX_FK_ContaCorrente_TabCarteiraCobranca
    on dbo.ContaCorrente (CodigoTabCarteiraCobranca);

create index IX_FK_ContaCorrente_TabModalidadeConta
    on dbo.ContaCorrente (CodigoTabModalidadeConta);

create index IX_FK_ContaCorrente_TabTipoConta
    on dbo.ContaCorrente (CodigoTabTipoConta);

create index IX_FK_ContaCorrente_TabTipoModalidadeBoleto
    on dbo.ContaCorrente (CodigoTabTipoModalidadeBoleto);

create index IX_FK_ContaCorrente_TabTipoRemessa
    on dbo.ContaCorrente (CodigoTabTipoRemessa);

create table dbo.TabTipoSexo
(
    CodigoTabTipoSexoId int identity
        constraint PK_TabTipoSexo
        primary key,
    Descricao           nvarchar(20) not null
);

create table dbo.TabTipoVinculo
(
    CodigoTabTipoVinculoId int identity
        constraint PK_TabTipoVinculo
        primary key,
    Descricao              nvarchar(50) not null
);

create table dbo.CadParticipante
(
    CadParticipanteId                       bigint identity
        constraint PK_CadParticipante
        primary key,
    CadAssinanteId                          int            not null,
    Codigo                                  nvarchar(60)   not null,
    CodigoTabTipoPersonalidade              int
        constraint FK_CAD_CadParticipante_SIS_TabTipoPersonalidade_CodigoTabTipoPersonalidade
            references dbo.TabTipoPersonalidade,
    Nome                                    nvarchar(100)  not null,
    NomeFantasia                            nvarchar(100)  not null,
    CpfCnpj                                 nvarchar(14)   not null,
    RG                                      nvarchar(20)   not null,
    Telefone1                               nvarchar(15)   not null,
    Telefone2                               nvarchar(15)   not null,
    InscricaoMunicipal                      nvarchar(14)   not null,
    InscricaoEstadual                       nvarchar(14)   not null,
    InscricaoEstadualST                     nvarchar(14)   not null,
    Email                                   nvarchar(100)  not null,
    Site                                    nvarchar(255)  not null,
    SUFRAMA                                 nvarchar(9)    not null,
    CodigoTabTipoContribuinteICMS           int
        constraint FK_CadParticipante_TabTipoContribuinteICMS
            references dbo.TabTipoContribuinteICMS,
    SituacaoRFB                             nvarchar(20)   not null,
    SituacaoRFBDataConsulta                 datetime,
    Observacao                              nvarchar(1000) not null,
    CRC                                     nvarchar(8)    not null,
    PISPASEP                                nvarchar(20)   not null,
    CodigoTabFuncao                         int
        constraint FK_CadParticipante_TabFuncao
            references dbo.TabFuncao,
    CodigoIBGE                              nvarchar(7)    not null,
    Especialidade                           nvarchar(255)  not null,
    Passaporte                              nvarchar(20)   not null,
    CodigoTabTipoSexoId                     int
        constraint FK_CadParticipante_TabTipoSexo
            references dbo.TabTipoSexo,
    DataAdmissaoContrato                    datetime,
    DataNascimento                          datetime,
    AceitaEncaixe                           bit            not null,
    CodigoTabTipoVinculoId                  int
        constraint FK_CadParticipante_TabTipoVinculo
            references dbo.TabTipoVinculo,
    PathFoto                                nvarchar(255)  not null,
    PossuiAlergia                           bit            not null,
    ObsPossuiAlergia                        nvarchar(500)  not null,
    TinturaEspecifica                       bit            not null,
    ObsTinturaEspecifica                    nvarchar(500)  not null,
    Remuneracao                             decimal(18, 2) not null,
    Contato                                 nvarchar(100)  not null,
    CadAssinantePerfilId                    nvarchar(50),
    CodigoTabTipoDescontoComissaoAssistente int
        constraint FK_CadParticipante_TabTipoDescontoComissaoAssistente
            references dbo.TabTipoDescontoComissaoAssistente,
    MostrarAgenda                           bit            not null,
    Created                              datetime       not null,
    UserCreate                              nvarchar(128)  not null,
    Updated                              datetime       not null,
    UserUpdate                              nvarchar(128)  not null,
    ClientExternalId                        nvarchar(36),
    constraint FK_CadParticipante_CadAssinantePerfil
        foreign key (CadAssinanteId, CadAssinantePerfilId) references dbo.CadAssinantePerfil
);

create table dbo.CadCategoriaReferencia
(
    CategoriaReferenciaId              int identity
        constraint PK_CadCategoriaReferencia
        primary key,
    CadAssinanteId                     int           not null,
    CadEmpresaId                       int           not null
        constraint FK_CadCategoriaReferencia_CadEmpresa
            references dbo.CadEmpresa,
    CodigoTabCategoriaTipo             int           not null
        constraint FK_CAD_CadCategoriaReferencia_SIS_TabCategoriaTipo_CodigoTabCategoriaTipo
            references dbo.TabCategoriaTipo,
    Nome                               nvarchar(50)  not null,
    TextoExplicativo                   nvarchar(50)  not null,
    ParticipanteFixo                   bit           not null,
    CadParticipanteId                  bigint
        constraint FK_CAD_CadCategoriaReferencia_CAD_CadParticipante_CadParticipanteId
            references dbo.CadParticipante,
    Contabilizar                       bit           not null,
    FinanceiraProvisaoDebito           nvarchar(50)  not null,
    CodigoTabTipoPlanoContaFinProvDeb  int           not null
        constraint FK_CAD_CadCategoriaReferencia_SIS_TabTipoPlanoConta_CodigoTabTipoPlanoContaFinProvDeb
            references dbo.TabTipoPlanoContaGrupo,
    FinanceiraProvisaoCredito          nvarchar(50)  not null,
    CodigoTabTipoPlanoContaFinProvCred int           not null
        constraint FK_CAD_CadCategoriaReferencia_SIS_TabTipoPlanoConta_CodigoTabTipoPlanoContaFinProvCred
            references dbo.TabTipoPlanoContaGrupo,
    FinanceiraProvisaoDescricao        nvarchar(255) not null,
    FinanceiraPagamentoDebito          nvarchar(50)  not null,
    CodigoTabTipoPlanoContaFinPagDeb   int           not null
        constraint FK_CAD_CadCategoriaReferencia_SIS_TabTipoPlanoConta_CodigoTabTipoPlanoContaFinPagDeb
            references dbo.TabTipoPlanoContaGrupo,
    FinanceiraPagamentoCredito         nvarchar(50)  not null,
    CodigoTabTipoPlanoContaFinPagCred  int           not null
        constraint FK_CAD_CadCategoriaReferencia_SIS_TabTipoPlanoConta_CodigoTabTipoPlanoContaFinPagCred
            references dbo.TabTipoPlanoContaGrupo,
    FinanceiraPagamentoDescricao       nvarchar(255) not null,
    ContabilProvisaoDebito             nvarchar(50),
    CodigoTabTipoPlanoContaCtbProvDeb  int
        constraint FK_CAD_CadCategoriaReferencia_SIS_TabTipoPlanoConta_CodigoTabTipoPlanoContaCtbProvDeb
            references dbo.TabTipoPlanoContaGrupo,
    ContabilProvisaoCredito            nvarchar(50),
    CodigoTabTipoPlanoContaCtbProvCred int
        constraint FK_CAD_CadCategoriaReferencia_SIS_TabTipoPlanoConta_CodigoTabTipoPlanoContaCtbProvCred
            references dbo.TabTipoPlanoContaGrupo,
    ContabilProvisaoDescricao          nvarchar(255),
    ContabilPagamentoDebito            nvarchar(50),
    CodigoTabTipoPlanoContaCtbPagDeb   int
        constraint FK_CAD_CadCategoriaReferencia_SIS_TabTipoPlanoConta_CodigoTabTipoPlanoContaCtbPagDeb
            references dbo.TabTipoPlanoContaGrupo,
    ContabilPagamentoCredito           nvarchar(50),
    CodigoTabTipoPlanoContaCtbPagCred  int
        constraint FK_CAD_CadCategoriaReferencia_SIS_TabTipoPlanoConta_CodigoTabTipoPlanoContaCtbPagCred
            references dbo.TabTipoPlanoContaGrupo,
    ContabilPagamentoDescricao         nvarchar(255)
);

create table dbo.CadCategoria
(
    CategoriaId            int identity
        constraint PK_CadCategoria
        primary key,
    CadAssinanteId         int          not null,
    CadEmpresaId           int          not null
        constraint FK_CadCategoria_CadEmpresa
            references dbo.CadEmpresa,
    CodigoTabCategoriaTipo int          not null
        constraint FK_CadCategoria_TabCategoriaTipo
            references dbo.TabCategoriaTipo,
    Nome                   nvarchar(50) not null,
    CategoriaReferenciaId  int
        constraint FK_CAD_CadCategoria_CAD_CadCategoriaReferencia_CadCategoriaReferenciaId
            references dbo.CadCategoriaReferencia,
    ParticipanteFixo       bit          not null,
    CadParticipanteId      bigint
        constraint FK_CAD_CadCategoria_CAD_CadParticipante_CadParticipanteId
            references dbo.CadParticipante,
    Contabilizar           bit          not null,
    CadPlanoContaDetalheId int
        constraint FK_CadCategoria_CadPlanoContaDetalhe
            references dbo.CadPlanoContaDetalhe,
    Sistema                bit          not null,
    CodigoTabCategoriaId   int
        constraint FK_CadCategoria_TabCategoriaPadrao
            references dbo.TabCategoriaPadrao
);

create index IX_FK_CAD_CadCategoria_CAD_CadCategoriaReferencia_CadCategoriaReferenciaId
    on dbo.CadCategoria (CategoriaReferenciaId);

create index IX_FK_CAD_CadCategoria_CAD_CadParticipante_CadParticipanteId
    on dbo.CadCategoria (CadParticipanteId);

create index IX_FK_CadCategoria_CadEmpresa
    on dbo.CadCategoria (CadEmpresaId);

create index IX_FK_CadCategoria_CadPlanoContaDetalhe
    on dbo.CadCategoria (CadPlanoContaDetalheId);

create index IX_FK_CadCategoria_TabCategoriaPadrao
    on dbo.CadCategoria (CodigoTabCategoriaId);

create index IX_FK_CadCategoria_TabCategoriaTipo
    on dbo.CadCategoria (CodigoTabCategoriaTipo);

create index IX_FK_CAD_CadCategoriaReferencia_CAD_CadParticipante_CadParticipanteId
    on dbo.CadCategoriaReferencia (CadParticipanteId);

create index IX_FK_CAD_CadCategoriaReferencia_SIS_TabCategoriaTipo_CodigoTabCategoriaTipo
    on dbo.CadCategoriaReferencia (CodigoTabCategoriaTipo);

create index IX_FK_CAD_CadCategoriaReferencia_SIS_TabTipoPlanoConta_CodigoTabTipoPlanoContaCtbPagCred
    on dbo.CadCategoriaReferencia (CodigoTabTipoPlanoContaCtbPagCred);

create index IX_FK_CAD_CadCategoriaReferencia_SIS_TabTipoPlanoConta_CodigoTabTipoPlanoContaCtbPagDeb
    on dbo.CadCategoriaReferencia (CodigoTabTipoPlanoContaCtbPagDeb);

create index IX_FK_CAD_CadCategoriaReferencia_SIS_TabTipoPlanoConta_CodigoTabTipoPlanoContaCtbProvCred
    on dbo.CadCategoriaReferencia (CodigoTabTipoPlanoContaCtbProvCred);

create index IX_FK_CAD_CadCategoriaReferencia_SIS_TabTipoPlanoConta_CodigoTabTipoPlanoContaCtbProvDeb
    on dbo.CadCategoriaReferencia (CodigoTabTipoPlanoContaCtbProvDeb);

create index IX_FK_CAD_CadCategoriaReferencia_SIS_TabTipoPlanoConta_CodigoTabTipoPlanoContaFinPagCred
    on dbo.CadCategoriaReferencia (CodigoTabTipoPlanoContaFinPagCred);

create index IX_FK_CAD_CadCategoriaReferencia_SIS_TabTipoPlanoConta_CodigoTabTipoPlanoContaFinPagDeb
    on dbo.CadCategoriaReferencia (CodigoTabTipoPlanoContaFinPagDeb);

create index IX_FK_CAD_CadCategoriaReferencia_SIS_TabTipoPlanoConta_CodigoTabTipoPlanoContaFinProvCred
    on dbo.CadCategoriaReferencia (CodigoTabTipoPlanoContaFinProvCred);

create index IX_FK_CAD_CadCategoriaReferencia_SIS_TabTipoPlanoConta_CodigoTabTipoPlanoContaFinProvDeb
    on dbo.CadCategoriaReferencia (CodigoTabTipoPlanoContaFinProvDeb);

create index IX_FK_CadCategoriaReferencia_CadEmpresa
    on dbo.CadCategoriaReferencia (CadEmpresaId);

create table dbo.CadEmpresaHomologacao
(
    CadEmpresaHomologacaoId  int identity
        constraint PK_CadEmpresaHomologacao
        primary key,
    CadAssinanteId           int    not null
        constraint FK_CadEmpresaHomologacao_CadAssinante
            references dbo.CadAssinante,
    CadParticipanteId        bigint not null
        constraint FK_CadEmpresaHomologacao_CadParticipante
            references dbo.CadParticipante,
    IdentificadorHomologacao int,
    UsuarioTipo              nvarchar(30),
    StatusHomologacao        nvarchar(50),
    DataHoraEnvioIntegracao  datetime
);

create index IX_FK_CadEmpresaHomologacao_CadAssinante
    on dbo.CadEmpresaHomologacao (CadAssinanteId);

create index IX_FK_CadEmpresaHomologacao_CadParticipante
    on dbo.CadEmpresaHomologacao (CadParticipanteId);

create table dbo.CadPacoteVenda
(
    CadPacoteVendaId  uniqueidentifier not null
        constraint PK_CadPacoteVenda
            primary key,
    CadPacoteId       int
        constraint FK_CadPacoteVenda_CadPacote
            references dbo.CadPacote,
    CadParticipanteId bigint
        constraint FK_CadPacoteVenda_CadParticipante
            references dbo.CadParticipante,
    DataVenda         datetime,
    CadEmpresaId      int
        constraint FK_CadPacoteVenda_CadEmpresa
            references dbo.CadEmpresa,
    ValorTotal        decimal(18, 2),
    Pago              bit              not null
);

create index IX_FK_CadPacoteVenda_CadEmpresa
    on dbo.CadPacoteVenda (CadEmpresaId);

create index IX_FK_CadPacoteVenda_CadPacote
    on dbo.CadPacoteVenda (CadPacoteId);

create index IX_FK_CadPacoteVenda_CadParticipante
    on dbo.CadPacoteVenda (CadParticipanteId);

create table dbo.CadPacoteVendaItem
(
    CadPacoteVendaItemId int              not null,
    CadPacoteVendaId     uniqueidentifier not null
        constraint FK_CadPacoteVendaItem_CadPacoteVenda
            references dbo.CadPacoteVenda,
    CadItemId            bigint,
    CadServicoId         int
        constraint FK_CadPacoteVendaItem_CadServico
            references dbo.CadServico,
    Quantidade           decimal(18, 3),
    ValorUnitario        decimal(18, 2),
    constraint PK_CadPacoteVendaItem
        primary key (CadPacoteVendaItemId, CadPacoteVendaId)
);

create index IX_FK_CadPacoteVendaItem_CadPacoteVenda
    on dbo.CadPacoteVendaItem (CadPacoteVendaId);

create index IX_FK_CadPacoteVendaItem_CadServico
    on dbo.CadPacoteVendaItem (CadServicoId);

create index IX_FK_CadParticipante_CadAssinantePerfil
    on dbo.CadParticipante (CadAssinanteId, CadAssinantePerfilId);

create index IX_FK_CAD_CadParticipante_SIS_TabTipoPersonalidade_CodigoTabTipoPersonalidade
    on dbo.CadParticipante (CodigoTabTipoPersonalidade);

create index IX_FK_CadParticipante_TabFuncao
    on dbo.CadParticipante (CodigoTabFuncao);

create index IX_FK_CadParticipante_TabTipoContribuinteICMS
    on dbo.CadParticipante (CodigoTabTipoContribuinteICMS);

create index IX_FK_CadParticipante_TabTipoDescontoComissaoAssistente
    on dbo.CadParticipante (CodigoTabTipoDescontoComissaoAssistente);

create index IX_FK_CadParticipante_TabTipoSexo
    on dbo.CadParticipante (CodigoTabTipoSexoId);

create index IX_FK_CadParticipante_TabTipoVinculo
    on dbo.CadParticipante (CodigoTabTipoVinculoId);

create table dbo.CadParticipanteBeneficiosCLT
(
    CadParticpanteId         bigint not null
        constraint FK_CadParticipanteBeneficiosCLT_CadParticipante
            references dbo.CadParticipante,
    CodigoTabTipoBeneficioId int    not null
        constraint FK_CadParticipanteBeneficiosCLT_TabTipoBeneficio
            references dbo.TabTipoBeneficio,
    Ativo                    bit    not null,
    constraint PK_CadParticipanteBeneficiosCLT
        primary key (CadParticpanteId, CodigoTabTipoBeneficioId)
);

create index IX_FK_CadParticipanteBeneficiosCLT_TabTipoBeneficio
    on dbo.CadParticipanteBeneficiosCLT (CodigoTabTipoBeneficioId);

create table dbo.CadParticipanteBloqueioAgenda
(
    CadParticipanteId bigint   not null
        constraint FK_CadParticipanteBloqueioAgenda_CadParticipante
            references dbo.CadParticipante,
    DataInicio        datetime not null,
    DataFinal         datetime not null,
    HoraInicial       time,
    HoraFinal         time,
    DiaInteiro        bit,
    Domingo           bit,
    Segunda           bit,
    Terca             bit,
    Quarta            bit,
    Quinta            bit,
    Sexta             bit,
    Sabado            bit,
    Observacao        nvarchar(255),
    constraint PK_CadParticipanteBloqueioAgenda
        primary key (CadParticipanteId, DataInicio, DataFinal)
);

create table dbo.CadParticipanteClienteFoto
(
    CadParticipanteClienteFotoId bigint identity
        constraint PK_CadParticipanteClienteFoto
        primary key,
    CadParticipanteId            bigint       not null
        constraint FK_CadParticipanteClienteFoto_CadParticipante2
            references dbo.CadParticipante,
    CodigoTabTipoParticipante    nvarchar(20) not null,
    CadEmpresaId                 int          not null,
    PathFoto                     nvarchar(255),
    DataRealizada                datetime,
    Historico                    nvarchar(255),
    ProfissionalId               bigint
        constraint FK_CadParticipanteClienteFoto_CadParticipante3
            references dbo.CadParticipante
);

create index IX_FK_CadParticipanteClienteFoto_CadParticipante2
    on dbo.CadParticipanteClienteFoto (CadParticipanteId);

create index IX_FK_CadParticipanteClienteFoto_CadParticipante3
    on dbo.CadParticipanteClienteFoto (ProfissionalId);

create table dbo.CadParticipanteContador
(
    CadContador_CadContadorId         int    not null
        constraint FK_CadParticipanteContador_CadContador
            references dbo.CadContador,
    CadParticipante_CadParticipanteId bigint not null
        constraint FK_CadParticipanteContador_CadParticipante
            references dbo.CadParticipante,
    constraint PK_CadParticipanteContador
        primary key (CadContador_CadContadorId, CadParticipante_CadParticipanteId)
);

create index IX_FK_CadParticipanteContador_CadParticipante
    on dbo.CadParticipanteContador (CadParticipante_CadParticipanteId);

create table dbo.CadParticipanteContrato
(
    CadParticipanteContratoId int identity
        constraint PK_CadParticipanteContrato
        primary key,
    CadParticipanteId         bigint        not null
        constraint FK_CadParticipanteContrato_CadParticipante
            references dbo.CadParticipante,
    CadEmpresaId              int           not null
        constraint FK_CadParticipanteContrato_CadEmpresa
            references dbo.CadEmpresa,
    ArquivoPath               nvarchar(255) not null,
    ArquivoNome               nvarchar(255) not null,
    DataInclusao              datetime      not null
);

create index IX_FK_CadParticipanteContrato_CadEmpresa
    on dbo.CadParticipanteContrato (CadEmpresaId);

create index IX_FK_CadParticipanteContrato_CadParticipante
    on dbo.CadParticipanteContrato (CadParticipanteId);

create table dbo.CadParticipanteDadoFiscal
(
    CadParticipanteId             bigint        not null
        constraint FK_CadParticipanteDadoFiscal_CadParticipante
            references dbo.CadParticipante,
    CadEmpresaId                  int           not null
        constraint FK_CadParticipanteDadoFiscal_CadEmpresa
            references dbo.CadEmpresa,
    CNPJCPF                       nvarchar(14)  not null,
    RazaoSocial                   nvarchar(100) not null,
    CodigoTabTipoGeraNFOperacaoId int           not null
        constraint FK_CadParticipanteDadoFiscal_TabTipoGeraNFOperacao
            references dbo.TabTipoGeraNFOperacao,
    IdentificacaoCSC              nvarchar(6)   not null,
    CodigoNFCe                    nvarchar(36)  not null,
    CodigoTabRegimeTributacaoId   int           not null
        constraint FK_CadParticipanteDadoFiscal_TabRegimeTributacao
            references dbo.TabRegimeTributacao,
    CodigoTabRegimeServicoId      int           not null
        constraint FK_CadParticipanteDadoFiscal_TabRegimeServico
            references dbo.TabRegimeServico,
    InscricaoEstadual             nvarchar(20)  not null,
    InscricaoMunicipal            nvarchar(20)  not null,
    NFeSerie                      nvarchar(3)   not null,
    NFeNumero                     nvarchar(10)  not null,
    NFeAmbiente                   int           not null
        constraint FK_CadParticipanteDadoFiscal_TabTipoAmbiente
            references dbo.TabTipoAmbiente,
    NFCeSerie                     nvarchar(3)   not null,
    NFCeNumero                    nvarchar(10)  not null,
    NFCeAmbiente                  int           not null
        constraint FK_CadParticipanteDadoFiscal_TabTipoAmbiente1
            references dbo.TabTipoAmbiente,
    CertificadoPath               nvarchar(255) not null,
    CertificadoSenha              nvarchar(50)  not null,
    CertificadoToken              nvarchar(255) not null,
    CertificadoDataVencimento     datetime      not null,
    NFSeSerieRPS                  nvarchar(6)   not null,
    NFSeNumeroRPS                 nvarchar(10)  not null,
    NFSeTipoAmbiente              int           not null
        constraint FK_CadParticipanteDadoFiscal_TabTipoAmbiente2
            references dbo.TabTipoAmbiente,
    constraint PK_CadParticipanteDadoFiscal
        primary key (CadParticipanteId, CadEmpresaId)
);

create index IX_FK_CadParticipanteDadoFiscal_CadEmpresa
    on dbo.CadParticipanteDadoFiscal (CadEmpresaId);

create index IX_FK_CadParticipanteDadoFiscal_TabRegimeServico
    on dbo.CadParticipanteDadoFiscal (CodigoTabRegimeServicoId);

create index IX_FK_CadParticipanteDadoFiscal_TabRegimeTributacao
    on dbo.CadParticipanteDadoFiscal (CodigoTabRegimeTributacaoId);

create index IX_FK_CadParticipanteDadoFiscal_TabTipoAmbiente
    on dbo.CadParticipanteDadoFiscal (NFeAmbiente);

create index IX_FK_CadParticipanteDadoFiscal_TabTipoAmbiente1
    on dbo.CadParticipanteDadoFiscal (NFCeAmbiente);

create index IX_FK_CadParticipanteDadoFiscal_TabTipoAmbiente2
    on dbo.CadParticipanteDadoFiscal (NFSeTipoAmbiente);

create index IX_FK_CadParticipanteDadoFiscal_TabTipoGeraNFOperacao
    on dbo.CadParticipanteDadoFiscal (CodigoTabTipoGeraNFOperacaoId);

create table dbo.CadParticipanteDadosBancarios
(
    CadParticipanteDadosBancariosId int identity
        constraint PK_CadParticipanteDadosBancarios
        primary key,
    CadParticipanteId               bigint       not null
        constraint FK_CadParticipanteDadosBancarios_CadParticipante
            references dbo.CadParticipante,
    CadEmpresaid                    int          not null
        constraint FK_CadParticipanteDadosBancarios_CadEmpresa
            references dbo.CadEmpresa,
    CodigoTabBanco                  int
        constraint FK_CadParticipanteDadosBancarios_TabBanco
            references dbo.TabBanco,
    Agencia                         nvarchar(20) not null,
    AgenciaDigito                   nvarchar(10) not null,
    Conta                           nvarchar(20) not null,
    CodigoTabTipoConta              int
        constraint FK_CadParticipanteDadosBancarios_TabTipoConta
            references dbo.TabTipoConta,
    TipoConta                       nvarchar(10) not null,
    Principal                       bit          not null
);

create index IX_FK_CadParticipanteDadosBancarios_CadEmpresa
    on dbo.CadParticipanteDadosBancarios (CadEmpresaid);

create index IX_FK_CadParticipanteDadosBancarios_CadParticipante
    on dbo.CadParticipanteDadosBancarios (CadParticipanteId);

create index IX_FK_CadParticipanteDadosBancarios_TabBanco
    on dbo.CadParticipanteDadosBancarios (CodigoTabBanco);

create index IX_FK_CadParticipanteDadosBancarios_TabTipoConta
    on dbo.CadParticipanteDadosBancarios (CodigoTabTipoConta);

create table dbo.CadParticipanteDadosPessoais
(
    CadParticipanteId          bigint        not null
        constraint PK_CadParticipanteDadosPessoais
            primary key
        constraint FK_CadParticipanteDadosPessoais_CadParticipante
            references dbo.CadParticipante,
    NomeMae                    nvarchar(100) not null,
    NomePai                    nvarchar(100) not null,
    Estado                     nvarchar(20)  not null,
    LocalNascimento            nvarchar(50)  not null,
    ConjugeNome                nvarchar(100) not null,
    ConjugeCPF                 nvarchar(14)  not null,
    ConjugeDataNascimento      datetime      not null,
    CodigoTabTipoEstadoCivilId int           not null
        constraint FK_CadParticipanteDadosPessoais_TabTipoEstadoCivil
            references dbo.TabTipoEstadoCivil,
    SinaisParticulares         nvarchar(500) not null
);

create index IX_FK_CadParticipanteDadosPessoais_TabTipoEstadoCivil
    on dbo.CadParticipanteDadosPessoais (CodigoTabTipoEstadoCivilId);

create table dbo.CadParticipanteDependente
(
    CadParticipanteDependenteId int identity
        constraint PK_CadParticipanteDependente
        primary key,
    CadParticipanteId           bigint        not null
        constraint FK_CadParticipanteDependente_CadParticipante
            references dbo.CadParticipante,
    Nome                        nvarchar(100) not null,
    CPF                         nvarchar(14)  not null,
    RGNumero                    nvarchar(20)  not null,
    RGOrgaoEmissor              nvarchar(20)  not null,
    RGEstado                    nvarchar(2)   not null,
    RGDataEmissao               datetime      not null,
    DataNascimento              datetime      not null,
    CodigoTabGrauParentesco     int           not null
        constraint FK_CadParticipanteDependente_TabGrauParentesco
            references dbo.TabGrauParentesco
);

create index IX_FK_CadParticipanteDependente_CadParticipante
    on dbo.CadParticipanteDependente (CadParticipanteId);

create index IX_FK_CadParticipanteDependente_TabGrauParentesco
    on dbo.CadParticipanteDependente (CodigoTabGrauParentesco);

create table dbo.CadParticipanteDiagnostico
(
    CadParticipanteDiagnosticoId bigint identity
        constraint PK_CadParticipanteDiagnostico
        primary key,
    CadParticipanteId            bigint   not null
        constraint FK_CadParticipanteDiagnostico_CadParticipante
            references dbo.CadParticipante,
    Data                         datetime not null,
    ProfissionalId               bigint   not null
        constraint FK_CadParticipanteDiagnostico_CadParticipante1
            references dbo.CadParticipante,
    TabCabeloComprimentoId       int
        constraint FK_CadParticipanteDiagnostico_TabCabeloComprimento
            references dbo.TabCabeloComprimento,
    TabCabeloEstadoId            int
        constraint FK_CadParticipanteDiagnostico_TabCabeloEstado
            references dbo.TabCabeloEstado,
    TabCabeloTipoId              int
        constraint FK_CadParticipanteDiagnostico_TabCabeloTipo
            references dbo.TabCabeloTipo,
    TabCabeloNaturezaId          int
        constraint FK_CadParticipanteDiagnostico_TabCabeloNatureza
            references dbo.TabCabeloNatureza,
    TabCabeloCouroEstadoId       int
        constraint FK_CadParticipanteDiagnostico_TabCabeloCouroEstado
            references dbo.TabCabeloCouroEstado,
    CabeloObservacao             varchar(255),
    TabPeleTonalidadeId          int
        constraint FK_CadParticipanteDiagnostico_TabPeleTonalidade
            references dbo.TabPeleTonalidade,
    TabPeleTipoId                int
        constraint FK_CadParticipanteDiagnostico_TabPeleTipo
            references dbo.TabPeleTipo,
    TabPeleEstadoId              int
        constraint FK_CadParticipanteDiagnostico_TabPeleEstado
            references dbo.TabPeleEstado,
    PeleObservacao               varchar(255)
);

create index IX_FK_CadParticipanteDiagnostico_CadParticipante
    on dbo.CadParticipanteDiagnostico (CadParticipanteId);

create index IX_FK_CadParticipanteDiagnostico_CadParticipante1
    on dbo.CadParticipanteDiagnostico (ProfissionalId);

create index IX_FK_CadParticipanteDiagnostico_TabCabeloComprimento
    on dbo.CadParticipanteDiagnostico (TabCabeloComprimentoId);

create index IX_FK_CadParticipanteDiagnostico_TabCabeloCouroEstado
    on dbo.CadParticipanteDiagnostico (TabCabeloCouroEstadoId);

create index IX_FK_CadParticipanteDiagnostico_TabCabeloEstado
    on dbo.CadParticipanteDiagnostico (TabCabeloEstadoId);

create index IX_FK_CadParticipanteDiagnostico_TabCabeloNatureza
    on dbo.CadParticipanteDiagnostico (TabCabeloNaturezaId);

create index IX_FK_CadParticipanteDiagnostico_TabCabeloTipo
    on dbo.CadParticipanteDiagnostico (TabCabeloTipoId);

create index IX_FK_CadParticipanteDiagnostico_TabPeleEstado
    on dbo.CadParticipanteDiagnostico (TabPeleEstadoId);

create index IX_FK_CadParticipanteDiagnostico_TabPeleTipo
    on dbo.CadParticipanteDiagnostico (TabPeleTipoId);

create index IX_FK_CadParticipanteDiagnostico_TabPeleTonalidade
    on dbo.CadParticipanteDiagnostico (TabPeleTonalidadeId);

create table dbo.CadParticipanteDocumentos
(
    CadParticipanteId            bigint       not null
        constraint PK_CadParticipanteDocumentos
            primary key
        constraint FK_CadParticipanteDocumentos_CadParticipante
            references dbo.CadParticipante,
    RGNumero                     nvarchar(20) not null,
    RGOrgaoEmissor               nvarchar(10) not null,
    RGUF                         nvarchar(2)  not null,
    RGDataEmissao                datetime,
    PISPASEP                     nvarchar(20) not null,
    CNH                          nvarchar(20) not null,
    CodigoTabCNHCategoria        nvarchar(10)
        constraint FK_CadParticipanteDocumentos_TabCNHCategoria
            references dbo.TabCNHCategoria,
    CNHValidade                  datetime,
    CNHDataEmissao               datetime,
    CertificadoReservistaNumero  nvarchar(20) not null,
    CertificadoReservistaSerie   nvarchar(20) not null,
    CertificadoReservistaEmissao datetime,
    TituloEleitorNumero          nvarchar(20) not null,
    TituloEleitorZona            nvarchar(20) not null,
    TituloEleitorSecao           nvarchar(20) not null,
    TituloEleitorUF              nvarchar(2)  not null,
    TituloEleitorEmissao         datetime,
    CTPS                         nvarchar(20) not null,
    CTPSSerie                    nvarchar(20) not null,
    CTPSEmissao                  datetime     not null,
    CodigoTabGrauInstrucaoId     int
        constraint FK_CadParticipanteDocumentos_TabGrauInstrucao1
            references dbo.TabGrauInstrucao
);

create index IX_FK_CadParticipanteDocumentos_TabCNHCategoria
    on dbo.CadParticipanteDocumentos (CodigoTabCNHCategoria);

create index IX_FK_CadParticipanteDocumentos_TabGrauInstrucao1
    on dbo.CadParticipanteDocumentos (CodigoTabGrauInstrucaoId);

create table dbo.CadParticipanteHabilidade
(
    CadParticipanteId bigint not null
        constraint FK_CadParticipanteHabilidade_CadParticipante
            references dbo.CadParticipante,
    CadServicoGrupoId int    not null
        constraint FK_CadParticipanteHabilidade_CadServicoGrupo
            references dbo.CadServicoGrupo,
    CadServicoId      int    not null
        constraint FK_CadParticipanteHabilidade_CadServico
            references dbo.CadServico,
    Duracao           time   not null,
    CadEmpresaId      int    not null
        constraint FK_CadParticipanteHabilidade_CadEmpresa
            references dbo.CadEmpresa,
    constraint PK_CadParticipanteHabilidade
        primary key (CadParticipanteId, CadServicoGrupoId, CadServicoId, CadEmpresaId)
);

create index IX_FK_CadParticipanteHabilidade_CadEmpresa
    on dbo.CadParticipanteHabilidade (CadEmpresaId);

create index IX_FK_CadParticipanteHabilidade_CadServico
    on dbo.CadParticipanteHabilidade (CadServicoId);

create index IX_FK_CadParticipanteHabilidade_CadServicoGrupo
    on dbo.CadParticipanteHabilidade (CadServicoGrupoId);

create table dbo.CadParticipanteProfissionalHorario
(
    CadParticipanteid bigint not null
        constraint FK_CadParticipanteProfissionalHorario_CadParticipante
            references dbo.CadParticipante,
    CadEmpresaId      int    not null
        constraint FK_CadParticipanteProfissionalHorario_CadEmpresa
            references dbo.CadEmpresa,
    TabDiaSemanaId    int    not null
        constraint FK_CadParticipanteProfissionalHorario_TabDiaSemana
            references dbo.TabDiaSemana,
    TabTipoPeriodoId  int    not null
        constraint FK_CadParticipanteProfissionalHorario_TabTipoPeriodo
            references dbo.TabTipoPeriodo,
    HorarioEntrada    time   not null,
    HorarioSaida      time   not null,
    constraint PK_CadParticipanteProfissionalHorario
        primary key (CadParticipanteid, CadEmpresaId, TabDiaSemanaId, TabTipoPeriodoId)
);

create index IX_FK_CadParticipanteProfissionalHorario_CadEmpresa
    on dbo.CadParticipanteProfissionalHorario (CadEmpresaId);

create index IX_FK_CadParticipanteProfissionalHorario_TabDiaSemana
    on dbo.CadParticipanteProfissionalHorario (TabDiaSemanaId);

create index IX_FK_CadParticipanteProfissionalHorario_TabTipoPeriodo
    on dbo.CadParticipanteProfissionalHorario (TabTipoPeriodoId);

create table dbo.CadParticipanteTabBloqueioAgenda
(
    CadParticipanteId bigint   not null
        constraint FK_CadParticipanteTabBloqueioAgenda_CadParticipante
            references dbo.CadParticipante,
    Data              datetime not null,
    Hora              time     not null,
    Motivo            nvarchar(100),
    Desbloqueio       bit,
    constraint PK_CadParticipanteTabBloqueioAgenda
        primary key (CadParticipanteId, Data, Hora)
);

create table dbo.CadParticipanteTipo
(
    CadParticipanteId         bigint       not null
        constraint FK_CadParticipanteTipo_CadParticipante
            references dbo.CadParticipante,
    CodigoTabTipoParticipante nvarchar(20) not null
        constraint FK_CadParticipanteTipo_TabTipoParticipante
            references dbo.TabTipoParticipante,
    Desligado                 bit          not null,
    DesligadoData             datetime,
    DesligadoDescricao        nvarchar(255),
    CadPlanoContaDetalheId    int
        constraint FK_CadParticipanteTipo_CadPlanoContaDetalhe
            references dbo.CadPlanoContaDetalhe,
    Remuneracao               decimal(18, 2),
    CadEmpresaId              int          not null
        constraint FK_CadParticipanteTipo_CadEmpresa
            references dbo.CadEmpresa,
    Ativo                     bit,
    constraint PK_CadParticipanteTipo
        primary key (CadParticipanteId, CodigoTabTipoParticipante, CadEmpresaId)
);

create index IX_FK_CadParticipanteTipo_CadEmpresa
    on dbo.CadParticipanteTipo (CadEmpresaId);

create index IX_FK_CadParticipanteTipo_CadPlanoContaDetalhe
    on dbo.CadParticipanteTipo (CadPlanoContaDetalheId);

create index IX_FK_CadParticipanteTipo_TabTipoParticipante
    on dbo.CadParticipanteTipo (CodigoTabTipoParticipante);

create table dbo.CadProfissionalHorario
(
    CadParticipanteId bigint   not null
        constraint FK_CadProfissionalHorario_CadParticipante
            references dbo.CadParticipante,
    CadAssinanteId    int      not null,
    CadEmpresaId      int      not null,
    Periodo           int      not null,
    DiaSemana         int      not null,
    HorarioEntrada    nchar(5) not null,
    HoarioSaida       nchar(5) not null,
    constraint PK_CadProfissionalHorario
        primary key (CadParticipanteId, DiaSemana, HorarioEntrada)
);

create table dbo.CadServicoComissaoProfissional
(
    CadServicoId      int            not null
        constraint FK_CadServicoComissaoProfissional_CadServico
            references dbo.CadServico,
    CadempresaId      int            not null
        constraint FK_TabHabilidadeComissaoProfissional_CadEmpresa
            references dbo.CadEmpresa,
    CadParticipanteId bigint         not null
        constraint FK_TabHabilidadeComissaoProfissional_CadParticipante
            references dbo.CadParticipante,
    CodigoTabFuncao   int            not null
        constraint FK_CadServicoComissaoProfissional_TabFuncao1
            references dbo.TabFuncao,
    TabTipoComissaoId int            not null
        constraint FK_TabHabilidadeComissaoProfissional_TabTipoComissao
            references dbo.TabTipoComissao,
    Valor             decimal(18, 2) not null,
    constraint PK_CadServicoComissaoProfissional
        primary key (CadServicoId, CadempresaId, CadParticipanteId, CodigoTabFuncao)
);

create index IX_FK_TabHabilidadeComissaoProfissional_CadEmpresa
    on dbo.CadServicoComissaoProfissional (CadempresaId);

create index IX_FK_TabHabilidadeComissaoProfissional_CadParticipante
    on dbo.CadServicoComissaoProfissional (CadParticipanteId);

create index IX_FK_CadServicoComissaoProfissional_TabFuncao1
    on dbo.CadServicoComissaoProfissional (CodigoTabFuncao);

create index IX_FK_TabHabilidadeComissaoProfissional_TabTipoComissao
    on dbo.CadServicoComissaoProfissional (TabTipoComissaoId);

create table dbo.CaixaFechamento
(
    CaixaFechamentoId     uniqueidentifier not null
        constraint PK_CaixaFechamento
            primary key,
    ContaCorrenteId       int
        constraint FK_CaixaFechamento_ContaCorrente
            references dbo.ContaCorrente,
    DataMovimento         datetime,
    Operador              bigint
        constraint FK_CaixaFechamento_CadParticipante
            references dbo.CadParticipante,
    CadEmpresaId          int
        constraint FK_CaixaFechamento_CadEmpresa
            references dbo.CadEmpresa,
    ValorAbertura         decimal(18, 2),
    ValorFechamento       decimal(18, 2),
    CaixaFechado          bit,
    ValorAberturaCheque   decimal(18, 2),
    ValorFechamentoCheque decimal(18, 2)
);

create index IX_FK_CaixaFechamento_CadEmpresa
    on dbo.CaixaFechamento (CadEmpresaId);

create index IX_FK_CaixaFechamento_CadParticipante
    on dbo.CaixaFechamento (Operador);

create index IX_FK_CaixaFechamento_ContaCorrente
    on dbo.CaixaFechamento (ContaCorrenteId);

create table dbo.Comanda
(
    ComandaId                           uniqueidentifier not null
        constraint PK_Comanda
            primary key,
    Created                          datetime         not null,
    UserCreate                          nvarchar(128)    not null,
    DataFechamento                      datetime,
    ClienteId                           bigint           not null
        constraint FK_Comanda_CadParticipante
            references dbo.CadParticipante
        constraint FK_Comanda_CadParticipanteCliente
            references dbo.CadParticipante,
    NumeroComanda                       nvarchar(20)     not null,
    ValorTotalComanda                   decimal(18, 2)   not null,
    PercentualDesconto                  decimal(5, 2)    not null,
    ValorDesconto                       decimal(18, 2)   not null,
    SubTotalPagar                       decimal(18, 2)   not null,
    ValorPago                           decimal(18, 2)   not null,
    Troco                               decimal(18, 2)   not null,
    GeraNotaFiscal                      bit              not null,
    GuardaTroco                         bit              not null,
    CodigoTabStatusComanda              int              not null
        constraint FK_Comanda_TabStatusComanda
            references dbo.TabStatusComanda,
    CadEmpresaId                        int              not null
        constraint FK_Comanda_CadEmpresa
            references dbo.CadEmpresa,
    CadPacoteVendaId                    uniqueidentifier
        constraint FK_Comanda_CadPacoteVenda
            references dbo.CadPacoteVenda,
    CaixaFechamentoId                   uniqueidentifier
        constraint FK_Comanda_CaixaFechamento
            references dbo.CaixaFechamento,
    ComandaPrincipal                    uniqueidentifier,
    ValorCredito                        decimal(18, 2)   not null,
    Updated                          datetime         not null,
    UserUpdate                          nvarchar(128)    not null,
    StatusPagamentoCieloOnline          int,
    DataNotificacaoPagamentoCieloOnline datetime,
    DataEnvioPagamentoCieloonline       datetime
);

create table dbo.Agenda
(
    ChaveAgenda             uniqueidentifier not null
        constraint PK_Agenda
            primary key,
    CadEmpresaId            int              not null
        constraint FK_Agenda_CadEmpresa
            references dbo.CadEmpresa,
    ClienteId               bigint           not null
        constraint FK_Agenda_CadParticipante
            references dbo.CadParticipante,
    ProfissionalId          bigint           not null
        constraint FK_Agenda_CadParticipante1
            references dbo.CadParticipante,
    Data                    datetime         not null,
    HoraChegadaCliente      time,
    HoraInicioAtendimento   time,
    HoraFimAtendimento      time,
    ClienteFaltou           bit              not null,
    MotivoCancelamento      nvarchar(20)     not null,
    ObservacaoCancelamento  nvarchar(255)    not null,
    DataCancelamento        datetime,
    ChaveAgendaPrincipal    uniqueidentifier,
    CodigoTabAgendaCorId    int              not null
        constraint FK_Agenda_TabAgendaCor
            references dbo.TabAgendaCor,
    CodigoTabAgendaStatusId int              not null
        constraint FK_Agenda_TabAgendaStatus
            references dbo.TabAgendaStatus,
    ComandaId               uniqueidentifier
        constraint FK_Agenda_Comanda
            references dbo.Comanda,
    ClientExternalId        nvarchar(36),
    constraint FK_Agenda_CadEmpresaAgendaCor
        foreign key (CadEmpresaId, CodigoTabAgendaCorId) references dbo.CadEmpresaAgendaCor
);

create index IX_FK_Agenda_CadEmpresa
    on dbo.Agenda (CadEmpresaId);

create index IX_FK_Agenda_CadEmpresaAgendaCor
    on dbo.Agenda (CadEmpresaId, CodigoTabAgendaCorId);

create index IX_FK_Agenda_CadParticipante
    on dbo.Agenda (ClienteId);

create index IX_FK_Agenda_CadParticipante1
    on dbo.Agenda (ProfissionalId);

create index IX_FK_Agenda_Comanda
    on dbo.Agenda (ComandaId);

create index IX_FK_Agenda_TabAgendaCor
    on dbo.Agenda (CodigoTabAgendaCorId);

create index IX_FK_Agenda_TabAgendaStatus
    on dbo.Agenda (CodigoTabAgendaStatusId);

create table dbo.AgendaServico
(
    AgendaServicoId          uniqueidentifier not null
        constraint PK_AgendaServico
            primary key,
    ChaveAgenda              uniqueidentifier not null
        constraint FK_AgendaServico_Agenda
            references dbo.Agenda,
    CadServicoId             int              not null
        constraint FK_AgendaServico_CadServico
            references dbo.CadServico,
    HoraInicial              time             not null,
    HoraFinal                time             not null,
    Valor                    decimal(18, 2)   not null,
    Created               datetime         not null,
    UserCreate               nvarchar(128)    not null,
    CodigoMotivoCancelamento nvarchar(20)
        constraint FK_AgendaServico_TabAgendaMotivoCancelamento
            references dbo.TabAgendaMotivoCancelamento,
    ObservacaoCancelamento   nvarchar(255)    not null,
    DataCancelamento         datetime         not null,
    Updated               datetime         not null,
    UserUpdate               nvarchar(128)    not null
);

create index IX_FK_AgendaServico_Agenda
    on dbo.AgendaServico (ChaveAgenda);

create index IX_FK_AgendaServico_CadServico
    on dbo.AgendaServico (CadServicoId);

create index IX_FK_AgendaServico_TabAgendaMotivoCancelamento
    on dbo.AgendaServico (CodigoMotivoCancelamento);

create table dbo.CadParticipanteContaCorrente
(
    CadParticipanteId bigint   not null
        constraint FK_CadParticipanteContaCorrente_CadParticipante
            references dbo.CadParticipante,
    CadempresaId      int      not null
        constraint FK_CadParticipanteContaCorrente_CadEmpresa
            references dbo.CadEmpresa,
    Data              datetime not null,
    ComandaId         uniqueidentifier
        constraint FK_CadParticipanteContaCorrente_Comanda
            references dbo.Comanda,
    TipoOperacao      nvarchar(2),
    Valor             decimal(18, 2),
    SaldoAtual        decimal(18, 2),
    Observacao        nvarchar(256),
    constraint PK_CadParticipanteContaCorrente
        primary key (CadParticipanteId, CadempresaId, Data)
);

create index IX_FK_CadParticipanteContaCorrente_CadEmpresa
    on dbo.CadParticipanteContaCorrente (CadempresaId);

create index IX_FK_CadParticipanteContaCorrente_Comanda
    on dbo.CadParticipanteContaCorrente (ComandaId);

create index IX_FK_Comanda_CadEmpresa
    on dbo.Comanda (CadEmpresaId);

create index IX_FK_Comanda_CadPacoteVenda
    on dbo.Comanda (CadPacoteVendaId);

create index IX_FK_Comanda_CadParticipante
    on dbo.Comanda (ClienteId);

create index IX_FK_Comanda_CadParticipanteCliente
    on dbo.Comanda (ClienteId);

create index IX_FK_Comanda_CaixaFechamento
    on dbo.Comanda (CaixaFechamentoId);

create index IX_FK_Comanda_TabStatusComanda
    on dbo.Comanda (CodigoTabStatusComanda);

create table dbo.ComandaComissaoProfissional
(
    ComandaComissaoProfId int              not null
        constraint PK_ComandaComissaoProfissional
            primary key,
    ComandaId             uniqueidentifier not null
        constraint FK_ComandaComissaoProfissional_Comanda
            references dbo.Comanda,
    CadParticipanteId     bigint           not null
        constraint FK_ComandaComissaoProfissional_CadParticipante
            references dbo.CadParticipante,
    CadServicoId          int
        constraint FK_ComandaComissaoProfissional_CadServico
            references dbo.CadServico,
    CadItemId             bigint,
    BaseComissao          decimal(18, 2),
    AliquotaComissao      decimal(18, 2),
    ValorComissao         decimal(18, 2)
);

create index IX_FK_ComandaComissaoProfissional_CadParticipante
    on dbo.ComandaComissaoProfissional (CadParticipanteId);

create index IX_FK_ComandaComissaoProfissional_CadServico
    on dbo.ComandaComissaoProfissional (CadServicoId);

create index IX_FK_ComandaComissaoProfissional_Comanda
    on dbo.ComandaComissaoProfissional (ComandaId);

create table dbo.ComandaPagamento
(
    ComandaId                   uniqueidentifier not null
        constraint FK_ComandaPagamento_Comanda
            references dbo.Comanda,
    ComandaPagamentoId          int              not null,
    CodigoTabFormaPagamento     int
        constraint FK_ComandaPagamento_TabFormaPagamento
            references dbo.TabFormaPagamento,
    Valor                       decimal(18, 2),
    CodigoTabBanco              int
        constraint FK_ComandaPagamento_TabBanco
            references dbo.TabBanco,
    NumeroCheque                nvarchar(6),
    VencimentoCheque            datetime,
    CodigoTabCartaoOperadora    int
        constraint FK_ComandaPagamento_TabCartaoOperadora
            references dbo.TabCartaoOperadora,
    CodigoTabCartaoOperacao     int
        constraint FK_ComandaPagamento_TabCartaoOperacao
            references dbo.TabCartaoOperacao,
    CodigoTabCartaoCredito      int
        constraint FK_ComandaPagamento_TabCartaoCredito
            references dbo.TabCartaoCredito,
    QuantidadeParcelas          int,
    Observacao                  nvarchar(256),
    ContaCorrenteId             int
        constraint FK_ComandaPagamento_ContaCorrente
            references dbo.ContaCorrente,
    ChaveOperacaoCieloOnline    nvarchar(max),
    HashOperacaoCieloOnline     nvarchar(512),
    DataHoraOperacaoCieloOnline datetime,
    constraint PK_ComandaPagamento
        primary key (ComandaId, ComandaPagamentoId)
);

create table dbo.CaixaFechamentoDetalhe
(
    CaixaFechamentoDetalheId         bigint identity
        constraint PK_CaixaFechamentoDetalhe
        primary key,
    CaixaFechamentoId                uniqueidentifier
        constraint FK_CaixaFechamentoDetalhe_CaixaFechamento
            references dbo.CaixaFechamento,
    ComandaId                        uniqueidentifier
        constraint FK_CaixaFechamentoDetalhe_Comanda
            references dbo.Comanda,
    ComandaPagamentoId               int,
    Valor                            decimal(18, 2),
    Historico                        nvarchar(256),
    CodigoTabCaixaFechamentoOperacao int
        constraint FK_CaixaFechamentoDetalhe_TabCaixaFechamentoOperacao
            references dbo.TabCaixaFechamentoOperacao,
    CodigoTabFormaPagamento          int
        constraint FK_CaixaFechamentoDetalhe_TabFormaPagamento
            references dbo.TabFormaPagamento,
    CodigoTabCartaoOperadora         int,
    CodigoTabCartaoCredito           int,
    CodigoTabCartaoOperacao          int,
    Operador                         bigint
        constraint FK_CaixaFechamentoDetalhe_CadParticipante
            references dbo.CadParticipante,
    ContaCorrenteId                  int
        constraint FK_CaixaFechamentoDetalhe_ContaCorrente
            references dbo.ContaCorrente,
    DataHoraMovimento                datetime,
    OperadorAutorizacao              bigint
        constraint FK_CaixaFechamentoDetalhe_CadParticipante1
            references dbo.CadParticipante,
    constraint FK_CaixaFechamentoDetalhe_ComandaPagamento
        foreign key (ComandaId, ComandaPagamentoId) references dbo.ComandaPagamento
);

create index IX_FK_CaixaFechamentoDetalhe_CadParticipante
    on dbo.CaixaFechamentoDetalhe (Operador);

create index IX_FK_CaixaFechamentoDetalhe_CadParticipante1
    on dbo.CaixaFechamentoDetalhe (OperadorAutorizacao);

create index IX_FK_CaixaFechamentoDetalhe_Comanda
    on dbo.CaixaFechamentoDetalhe (ComandaId);

create index IX_FK_CaixaFechamentoDetalhe_ComandaPagamento
    on dbo.CaixaFechamentoDetalhe (ComandaId, ComandaPagamentoId);

create index IX_FK_CaixaFechamentoDetalhe_CaixaFechamento
    on dbo.CaixaFechamentoDetalhe (CaixaFechamentoId);

create index IX_FK_CaixaFechamentoDetalhe_ContaCorrente
    on dbo.CaixaFechamentoDetalhe (ContaCorrenteId);

create index IX_FK_CaixaFechamentoDetalhe_TabCaixaFechamentoOperacao
    on dbo.CaixaFechamentoDetalhe (CodigoTabCaixaFechamentoOperacao);

create index IX_FK_CaixaFechamentoDetalhe_TabFormaPagamento
    on dbo.CaixaFechamentoDetalhe (CodigoTabFormaPagamento);

create index IX_FK_ComandaPagamento_ContaCorrente
    on dbo.ComandaPagamento (ContaCorrenteId);

create index IX_FK_ComandaPagamento_TabBanco
    on dbo.ComandaPagamento (CodigoTabBanco);

create index IX_FK_ComandaPagamento_TabCartaoCredito
    on dbo.ComandaPagamento (CodigoTabCartaoCredito);

create index IX_FK_ComandaPagamento_TabCartaoOperacao
    on dbo.ComandaPagamento (CodigoTabCartaoOperacao);

create index IX_FK_ComandaPagamento_TabCartaoOperadora
    on dbo.ComandaPagamento (CodigoTabCartaoOperadora);

create index IX_FK_ComandaPagamento_TabFormaPagamento
    on dbo.ComandaPagamento (CodigoTabFormaPagamento);

create table dbo.ContaPagar
(
    ContaPagarId                                  int identity
        constraint PK_ContaPagar
        primary key,
    CadAssinanteId                                int            not null,
    CadEmpresaId                                  int            not null
        constraint FK_CadContaPagar_CadEmpresa
            references dbo.CadEmpresa,
    CadParticipanteId                             bigint         not null
        constraint FK_CAD_CadContaPagar_CAD_CadParticipante_CadParticipanteId
            references dbo.CadParticipante,
    CodigoTabTipoDocTitulo                        int            not null
        constraint FK_CAD_CadContaPagar_SIS_TabTipoDocTitulo_CodigoTabTipoDocTitulo
            references dbo.TabTipoDocTitulo,
    ContaCorrenteId                               int            not null
        constraint FK_ContaPagar_ContaCorrente
            references dbo.ContaCorrente,
    Documento                                     nvarchar(50)   not null,
    Parcela                                       nvarchar(10)   not null,
    NumeroBoleto                                  nvarchar(50),
    DataEmissao                                   datetime       not null,
    DataVencimento                                datetime       not null,
    DataPagamento                                 datetime,
    ValorTotalOriginal                            decimal(18, 2) not null,
    ValorTotalPagamento                           decimal(18, 2) not null,
    ValorMulta                                    decimal(18, 2) not null,
    ValorJuros                                    decimal(18, 2) not null,
    ValorDesconto                                 decimal(18, 2) not null,
    CodigoStatusPagarReceber                      nvarchar(20)
        constraint FK_ContaPagar_TabStatusPagarReceber
            references dbo.TabStatusPagarReceber,
    FinanProvisaoDebitoCadPlanoContaDetalheId     int,
    FinanProvisaoCreditoCadPlanoContaDetalheId    int,
    ContabilProvisaoDebitoCadPlanoContaDetalheId  int,
    ContabilProvisaoCreditoCadPlanoContaDetalheId int,
    Contabilizar                                  bit
);

create index IX_FK_CadContaPagar_CadEmpresa
    on dbo.ContaPagar (CadEmpresaId);

create index IX_FK_CAD_CadContaPagar_CAD_CadParticipante_CadParticipanteId
    on dbo.ContaPagar (CadParticipanteId);

create index IX_FK_ContaPagar_ContaCorrente
    on dbo.ContaPagar (ContaCorrenteId);

create index IX_FK_CAD_CadContaPagar_SIS_TabTipoDocTitulo_CodigoTabTipoDocTitulo
    on dbo.ContaPagar (CodigoTabTipoDocTitulo);

create index IX_FK_ContaPagar_TabStatusPagarReceber
    on dbo.ContaPagar (CodigoStatusPagarReceber);

create table dbo.ContaPagarBaixa
(
    ContaPagarBaixaId                          int identity
        constraint PK_ContaPagarBaixa
        primary key,
    CadAssinanteId                             int            not null,
    CadEmpresaId                               int            not null,
    ContaPagarId                               int            not null
        constraint FK_ContaPagarBaixa_ContaPagar
            references dbo.ContaPagar,
    ContaCorrenteId                            int            not null
        constraint FK_ContaPagarBaixa_ContaCorrente
            references dbo.ContaCorrente,
    DataPagamento                              datetime       not null,
    ValorTotalBaixado                          decimal(18, 2) not null,
    ValorMulta                                 decimal(18, 2) not null,
    ValorJuros                                 decimal(18, 2) not null,
    ValorDesconto                              decimal(18, 2) not null,
    ValorTotalPagamento                        decimal(18, 2) not null,
    FinanBaixaDebitoCadPlanoContaDetalheId     int,
    FinanBaixaCreditoCadPlanoContaDetalheId    int,
    ContabilBaixaDebitoCadPlanoContaDetalheId  int,
    ContabilBaixaCreditoCadPlanoContaDetalheId int
);

create index IX_FK_ContaPagarBaixa_ContaCorrente
    on dbo.ContaPagarBaixa (ContaCorrenteId);

create index IX_FK_ContaPagarBaixa_ContaPagar
    on dbo.ContaPagarBaixa (ContaPagarId);

create table dbo.ContaPagarCategoria
(
    CadAssinanteId      int            not null,
    CadEmpresaId        int            not null,
    ContaPagarId        int            not null
        constraint FK_CAD_CadContaPagarCategoria_CAD_CadContaPagar_CadContaPagarId
            references dbo.ContaPagar,
    CategoriaId         int            not null
        constraint FK_CAD_CadContaPagarCategoria_CAD_CadCategoria_CadCategoriaId
            references dbo.CadCategoria,
    ValorTotalCategoria decimal(18, 2) not null,
    constraint PK_ContaPagarCategoria
        primary key (ContaPagarId, CategoriaId)
);

create index IX_FK_CAD_CadContaPagarCategoria_CAD_CadCategoria_CadCategoriaId
    on dbo.ContaPagarCategoria (CategoriaId);

create table dbo.ContaReceber
(
    ContaReceberId                                int identity
        constraint PK_ContaReceber
        primary key,
    CadAssinanteId                                int            not null
        constraint FK_ContaReceber_CadAssinante
            references dbo.CadAssinante,
    CadEmpresaId                                  int            not null
        constraint FK_CadContaReceber_CadEmpresa
            references dbo.CadEmpresa,
    CadParticipanteId                             bigint         not null
        constraint FK_CAD_CadContaReceber_CAD_CadParticipante_CadParticipanteId
            references dbo.CadParticipante,
    CodigoTabTipoDocTitulo                        int            not null
        constraint FK_CAD_CadContaReceber_SIS_TabTipoDocTitulo_CodigoTabTipoDocTitulo
            references dbo.TabTipoDocTitulo,
    ContaCorrenteId                               int            not null
        constraint FK_ContaReceber_ContaCorrente
            references dbo.ContaCorrente,
    Documento                                     nvarchar(50)   not null,
    DataEmissao                                   datetime       not null,
    DataVencimento                                datetime       not null,
    DataPagamento                                 datetime,
    DataRecebimento                               datetime,
    ValorTotalOriginal                            decimal(18, 2) not null,
    ValorTotalRecebimento                         decimal(18, 2) not null,
    ValorMulta                                    decimal(18, 2) not null,
    ValorJuros                                    decimal(18, 2) not null,
    ValorDesconto                                 decimal(18, 2) not null,
    CodigoStatusPagarReceber                      nvarchar(20)
        constraint FK_ContaReceber_TabStatusPagarReceber
            references dbo.TabStatusPagarReceber,
    NossoNumero                                   nvarchar(20),
    Impresso                                      bit,
    Remessa                                       bit,
    Email                                         bit,
    NumeroRemessa                                 int,
    FinanProvisaoDebitoCadPlanoContaDetalheId     int,
    FinanProvisaoCreditoCadPlanoContaDetalheId    int,
    ContabilProvisaoDebitoCadPlanoContaDetalheId  int,
    ContabilProvisaoCreditoCadPlanoContaDetalheId int,
    Parcela                                       nvarchar(10)   not null,
    Contabilizar                                  bit,
    constraint FK_ContaReceber_BoletoRemessa
        foreign key (NumeroRemessa, ContaCorrenteId) references dbo.BoletoRemessa
);

create index IX_FK_ContaReceber_CadAssinante
    on dbo.ContaReceber (CadAssinanteId);

create index IX_FK_CadContaReceber_CadEmpresa
    on dbo.ContaReceber (CadEmpresaId);

create index IX_FK_CAD_CadContaReceber_CAD_CadParticipante_CadParticipanteId
    on dbo.ContaReceber (CadParticipanteId);

create index IX_FK_ContaReceber_BoletoRemessa
    on dbo.ContaReceber (NumeroRemessa, ContaCorrenteId);

create index IX_FK_ContaReceber_ContaCorrente
    on dbo.ContaReceber (ContaCorrenteId);

create index IX_FK_CAD_CadContaReceber_SIS_TabTipoDocTitulo_CodigoTabTipoDocTitulo
    on dbo.ContaReceber (CodigoTabTipoDocTitulo);

create index IX_FK_ContaReceber_TabStatusPagarReceber
    on dbo.ContaReceber (CodigoStatusPagarReceber);

create table dbo.ContaReceberBaixa
(
    ContaReceberBaixaId int identity
        constraint PK_ContaReceberBaixa
        primary key,
    CadAssinanteId      int            not null,
    CadEmpresaId        int            not null,
    ContaReceberId      int            not null
        constraint FK_CAD_CadContaReceberBaixa_CAD_CadContaReceber_CadContaReceberId
            references dbo.ContaReceber,
    ContaCorrenteId     int            not null
        constraint FK_ContaReceberBaixa_ContaCorrente
            references dbo.ContaCorrente,
    DataPagamento       datetime       not null,
    ValorTotalBaixado   decimal(18, 2) not null,
    ValorMulta          decimal(18, 2) not null,
    ValorJuros          decimal(18, 2) not null,
    ValorDesconto       decimal(18, 2) not null,
    ValorTotalPagamento decimal(18, 2) not null
);

create table dbo.BancoCaixa
(
    BancoCaixaId           int identity
        constraint PK_BancoCaixa
        primary key,
    ContaCorrenteId        int            not null
        constraint FK_BancoCaixa_ContaCorrente
            references dbo.ContaCorrente,
    ContaPagarId           int
        constraint FK_BancoCaixa_ContaPagar
            references dbo.ContaPagar,
    ContaReceberId         int
        constraint FK_BancoCaixa_ContaReceber
            references dbo.ContaReceber,
    CategoriaId            int
        constraint FK_BancoCaixa_CadCategoria
            references dbo.CadCategoria,
    CadAssinanteId         int            not null,
    CadEmpresaId           int            not null,
    DataMovimentacao       datetime       not null,
    Descricao              nvarchar(255)  not null,
    ValorMovimentacao      decimal(18, 6) not null,
    Conciliado             bit            not null,
    TipoLancamento         nvarchar(20),
    CadParticipanteId      bigint
        constraint FK_BancoCaixa_CadParticipante
            references dbo.CadParticipante,
    NumeroDocumento        nvarchar(50),
    TipoDebitoCredito      char,
    SaldoAnterior          decimal(18, 6) not null,
    ContaCorrenteDestinoId int
        constraint FK_BancoCaixa_ContaCorrente1
            references dbo.ContaCorrente,
    ContaCorrenteOrigemId  int
        constraint FK_BancoCaixa_ContaCorrente2
            references dbo.ContaCorrente,
    ContaPagarBaixaId      int
        constraint FK_BancoCaixa_ContaPagarBaixa
            references dbo.ContaPagarBaixa,
    ContaReceberBaixaId    int
        constraint FK_BancoCaixa_ContaReceberBaixa
            references dbo.ContaReceberBaixa
);

create index IX_FK_BancoCaixa_CadCategoria
    on dbo.BancoCaixa (CategoriaId);

create index IX_FK_BancoCaixa_CadParticipante
    on dbo.BancoCaixa (CadParticipanteId);

create index IX_FK_BancoCaixa_ContaCorrente
    on dbo.BancoCaixa (ContaCorrenteId);

create index IX_FK_BancoCaixa_ContaCorrente1
    on dbo.BancoCaixa (ContaCorrenteDestinoId);

create index IX_FK_BancoCaixa_ContaCorrente2
    on dbo.BancoCaixa (ContaCorrenteOrigemId);

create index IX_FK_BancoCaixa_ContaPagar
    on dbo.BancoCaixa (ContaPagarId);

create index IX_FK_BancoCaixa_ContaPagarBaixa
    on dbo.BancoCaixa (ContaPagarBaixaId);

create index IX_FK_BancoCaixa_ContaReceber
    on dbo.BancoCaixa (ContaReceberId);

create index IX_FK_BancoCaixa_ContaReceberBaixa
    on dbo.BancoCaixa (ContaReceberBaixaId);

create index IX_FK_ContaReceberBaixa_ContaCorrente
    on dbo.ContaReceberBaixa (ContaCorrenteId);

create index IX_FK_CAD_CadContaReceberBaixa_CAD_CadContaReceber_CadContaReceberId
    on dbo.ContaReceberBaixa (ContaReceberId);

create table dbo.ContaReceberBoletoRemessa
(
    BoletoRemessa1_NumeroRemessa   int not null,
    BoletoRemessa1_ContaCorrenteId int not null,
    ContaReceber1_ContaReceberId   int not null
        constraint FK_ContaReceberBoletoRemessa_ContaReceber
            references dbo.ContaReceber,
    constraint PK_ContaReceberBoletoRemessa
        primary key (BoletoRemessa1_NumeroRemessa, BoletoRemessa1_ContaCorrenteId, ContaReceber1_ContaReceberId),
    constraint FK_ContaReceberBoletoRemessa_BoletoRemessa
        foreign key (BoletoRemessa1_NumeroRemessa, BoletoRemessa1_ContaCorrenteId) references dbo.BoletoRemessa
);

create index IX_FK_ContaReceberBoletoRemessa_ContaReceber
    on dbo.ContaReceberBoletoRemessa (ContaReceber1_ContaReceberId);

create table dbo.ContaReceberCategoria
(
    CadAssinanteId      int            not null,
    CadEmpresaId        int            not null,
    ContaReceberId      int            not null
        constraint FK_CAD_CadContaReceberCategoria_CAD_CadContaReceber_CadContaReceberId
            references dbo.ContaReceber,
    CategoriaId         int            not null
        constraint FK_CAD_CadContaReceberCategoria_CAD_CadCategoria_CadCategoriaId
            references dbo.CadCategoria,
    ValorTotalCategoria decimal(18, 2) not null,
    constraint PK_ContaReceberCategoria
        primary key (ContaReceberId, CategoriaId)
);

create index IX_FK_CAD_CadContaReceberCategoria_CAD_CadCategoria_CadCategoriaId
    on dbo.ContaReceberCategoria (CategoriaId);

create table dbo.DocFiscal
(
    DocFiscalId               bigint identity
        constraint PK_DocFiscal
        primary key,
    CadAssinanteId            int            not null
        constraint FK_DocFiscal_CadAssinante
            references dbo.CadAssinante,
    CadEmpresaId              int            not null
        constraint FK_DocFiscal_CadEmpresa
            references dbo.CadEmpresa,
    CodigoTabIndOperacao      nchar          not null
        constraint FK_FIS_DocFiscal_SIS_TabIndOperacao_CodigoTabIndOperacao
            references dbo.TabIndOperacao,
    CodigoTabModDocumento     nchar(2)       not null
        constraint FK_FIS_DocFiscal_SIS_TabModDocumento_CodigoTabModDocumento
            references dbo.TabModDocumento,
    DataDocumento             datetime       not null,
    DataEntradaSaida          datetime       not null,
    NumeroDocumento           bigint         not null,
    Serie                     nchar(3)       not null,
    CodigoTabIndFrete         nchar          not null
        constraint FK_FIS_DocFiscal_SIS_TabIndFrete_CodigoTabIndFrete
            references dbo.TabIndFrete,
    CodigoTabIndEmitente      nchar          not null
        constraint FK_FIS_DocFiscal_SIS_TabIndEmitente_CodigoTabIndEmitente
            references dbo.TabIndEmitente,
    CodigoTabSitDocumento     nchar(2)       not null
        constraint FK_FIS_DocFiscal_SIS_TabSitDocumento_CodigoTabSitDocumento
            references dbo.TabSitDocumento,
    CadParticipanteId         bigint
        constraint FK_FIS_DocFiscal_CAD_CadParticipante_IDCadParticipante
            references dbo.CadParticipante,
    ChaveNFE                  nchar(44)      not null,
    CodigoTabIndPagamento     nchar          not null
        constraint FK_FIS_DocFiscal_SIS_TabIndPagamento_CodigoTabIndPagamento
            references dbo.TabIndPagamento,
    ValorTotal                decimal(18, 2) not null,
    ValorISS                  decimal(18, 2) not null,
    ValorMercadorias          decimal(18, 2) not null,
    ValorDesconto             decimal(18, 2) not null,
    ValorFrete                decimal(18, 2) not null,
    ValorOutrasDespesas       decimal(18, 2) not null,
    ValorIPI                  decimal(18, 2) not null,
    ValorSeguro               decimal(18, 2) not null,
    ValorBCICMS               decimal(18, 2) not null,
    ValorICMS                 decimal(18, 2) not null,
    ValorBCICMSST             decimal(18, 2) not null,
    ValorICMSST               decimal(18, 2) not null,
    ValorPIS                  decimal(18, 2) not null,
    ValorPISST                decimal(18, 2) not null,
    ValorCOFINS               decimal(18, 2) not null,
    ValorCOFINSST             decimal(18, 2) not null,
    ValorAbatimentoZFM        decimal(18, 2) not null,
    UFDestinoICMSST           nchar(2)       not null,
    ValorServicoNT            decimal(18, 2) not null,
    ValorBCISSQN              decimal(18, 2) not null,
    ValorISSQN                decimal(18, 2) not null,
    ValorBCIRRF               decimal(18, 2) not null,
    ValorIRRF                 decimal(18, 2) not null,
    ValorBCPrevSocial         decimal(18, 2) not null,
    ValorPrevSocial           decimal(18, 2) not null,
    CodigoObservacao          nvarchar(2000),
    ComandaId                 uniqueidentifier
        constraint FK_DocFiscal_Comanda
            references dbo.Comanda,
    LinkDanfe                 nvarchar(2000),
    InformacoesComplementares varchar(5000)  not null,
    CodigoTabTipoAmbienteId   int            not null
        constraint FK_DocFiscal_TabTipoAmbiente
            references dbo.TabTipoAmbiente,
    ProtocoloNumero           bigint,
    ProtocoloDataRecebimento  datetime,
    CNPJ_CPFConsumidorFinal   nvarchar(14),
    LinkQRCode                nvarchar(2000),
    DataCancelamento          datetime,
    MotivoCancelamento        nvarchar(255)
);

create index IX_FK_DocFiscal_CadAssinante
    on dbo.DocFiscal (CadAssinanteId);

create index IX_FK_DocFiscal_CadEmpresa
    on dbo.DocFiscal (CadEmpresaId);

create index IX_FK_FIS_DocFiscal_CAD_CadParticipante_IDCadParticipante
    on dbo.DocFiscal (CadParticipanteId);

create index IX_FK_DocFiscal_Comanda
    on dbo.DocFiscal (ComandaId);

create index IX_FK_DocFiscal_TabTipoAmbiente
    on dbo.DocFiscal (CodigoTabTipoAmbienteId);

create index IX_FK_FIS_DocFiscal_SIS_TabIndEmitente_CodigoTabIndEmitente
    on dbo.DocFiscal (CodigoTabIndEmitente);

create index IX_FK_FIS_DocFiscal_SIS_TabIndFrete_CodigoTabIndFrete
    on dbo.DocFiscal (CodigoTabIndFrete);

create index IX_FK_FIS_DocFiscal_SIS_TabIndOperacao_CodigoTabIndOperacao
    on dbo.DocFiscal (CodigoTabIndOperacao);

create index IX_FK_FIS_DocFiscal_SIS_TabIndPagamento_CodigoTabIndPagamento
    on dbo.DocFiscal (CodigoTabIndPagamento);

create index IX_FK_FIS_DocFiscal_SIS_TabModDocumento_CodigoTabModDocumento
    on dbo.DocFiscal (CodigoTabModDocumento);

create index IX_FK_FIS_DocFiscal_SIS_TabSitDocumento_CodigoTabSitDocumento
    on dbo.DocFiscal (CodigoTabSitDocumento);

create table dbo.DocFiscalCFEReferenciado
(
    DocFiscalId           bigint       not null
        constraint FK_FIS_DocFiscalCFEReferenciado_FIS_DocFiscal_IDDocFiscal
            references dbo.DocFiscal,
    ChaveCFE              nvarchar(44) not null,
    DataEmissaoDocumentoo datetime     not null,
    NumeroDocumento       nvarchar(9)  not null,
    CodigoTabModDocumento nchar(2)     not null
        constraint FK_FIS_DocFiscalCFEReferenciado_SIS_TabModDocumento_CodigoTabModDocumento
            references dbo.TabModDocumento,
    NumeroSerieSAT        nvarchar(9)  not null,
    constraint PK_DocFiscalCFEReferenciado
        primary key (DocFiscalId, ChaveCFE)
);

create index IX_FK_FIS_DocFiscalCFEReferenciado_SIS_TabModDocumento_CodigoTabModDocumento
    on dbo.DocFiscalCFEReferenciado (CodigoTabModDocumento);

create table dbo.DocFiscalDocReferenciado
(
    DocFiscalId           bigint        not null
        constraint FK_FIS_DocFiscalDocReferenciado_FIS_DocFiscal_IDDocFiscal
            references dbo.DocFiscal,
    DataEmissaoDocumento  datetime      not null,
    NumeroDocumento       nvarchar(9)   not null,
    CadParticipanteId     bigint        not null
        constraint FK_FIS_DocFiscalDocReferenciado_CAD_CadParticipante_IDCadParticipante
            references dbo.CadParticipante,
    CodigoTabIndEmitente  nchar         not null
        constraint FK_FIS_DocFiscalDocReferenciado_SIS_TabIndEmitente_CodigoTabIndEmitente
            references dbo.TabIndEmitente,
    CodigoTabModDocumento nchar(2)      not null
        constraint FK_FIS_DocFiscalDocReferenciado_SIS_TabModDocumento_CodigoTabModDocumento
            references dbo.TabModDocumento,
    Serie                 nvarchar(4)   not null,
    SubSerie              nvarchar(3)   not null,
    CodigoTabIndOperacao  nchar         not null
        constraint FK_FIS_DocFiscalDocReferenciado_SIS_TabIndOperacao_CodigoTabIndOperacao
            references dbo.TabIndOperacao,
    CodigoInformacao      nchar(6)      not null,
    DescricaoComplementar nvarchar(255) not null,
    constraint PK_DocFiscalDocReferenciado
        primary key (DocFiscalId, DataEmissaoDocumento, NumeroDocumento, CadParticipanteId)
);

create index IX_FK_FIS_DocFiscalDocReferenciado_CAD_CadParticipante_IDCadParticipante
    on dbo.DocFiscalDocReferenciado (CadParticipanteId);

create index IX_FK_FIS_DocFiscalDocReferenciado_SIS_TabIndEmitente_CodigoTabIndEmitente
    on dbo.DocFiscalDocReferenciado (CodigoTabIndEmitente);

create index IX_FK_FIS_DocFiscalDocReferenciado_SIS_TabIndOperacao_CodigoTabIndOperacao
    on dbo.DocFiscalDocReferenciado (CodigoTabIndOperacao);

create index IX_FK_FIS_DocFiscalDocReferenciado_SIS_TabModDocumento_CodigoTabModDocumento
    on dbo.DocFiscalDocReferenciado (CodigoTabModDocumento);

create table dbo.DocFiscalImportacao
(
    DocFiscalId                bigint         not null
        constraint FK_FIS_DocFiscalImportacao_FIS_DocFiscal_IDDocFiscal
            references dbo.DocFiscal,
    NumeroDocumento            nchar(12)      not null,
    CodigoTabTipoDocImportacao int            not null
        constraint FK_FIS_DocFiscalImportacao_SIS_TabTipoDocImportacao_CodigoTabTipoDocImportacao
            references dbo.TabTipoDocImportacao,
    NumeroDrawback             nchar(20)      not null,
    ValorPIS                   decimal(18, 2) not null,
    ValorCOFINS                decimal(18, 2) not null,
    constraint PK_DocFiscalImportacao
        primary key (DocFiscalId, NumeroDocumento)
);

create index IX_FK_FIS_DocFiscalImportacao_SIS_TabTipoDocImportacao_CodigoTabTipoDocImportacao
    on dbo.DocFiscalImportacao (CodigoTabTipoDocImportacao);

create table dbo.DocFiscalProcReferenciado
(
    DocFiscalId                bigint        not null
        constraint FK_FIS_DocFiscalProcReferenciado_FIS_DocFiscal_IDDocFiscal
            references dbo.DocFiscal,
    IdentificacaoProcesso      nvarchar(15)  not null,
    CodigoTabIndOrigemProcesso nchar         not null
        constraint FK_FIS_DocFiscalProcReferenciado_SIS_TabIndOrigemProcesso_CodigoTabIndOrigemProcesso
            references dbo.TabIndOrigemProcesso,
    CodigoInformacao           nchar(6)      not null,
    DescricaoComplementar      nvarchar(255) not null,
    constraint PK_DocFiscalProcReferenciado
        primary key (DocFiscalId, IdentificacaoProcesso)
);

create index IX_FK_FIS_DocFiscalProcReferenciado_SIS_TabIndOrigemProcesso_CodigoTabIndOrigemProcesso
    on dbo.DocFiscalProcReferenciado (CodigoTabIndOrigemProcesso);

create table dbo.DocFiscalRetorno
(
    DocFiscalRetornoId     uniqueidentifier not null
        constraint PK_DocFiscalRetorno
            primary key,
    DocFiscalId            bigint           not null
        constraint FK_DocFiscalRetorno_DocFiscal1
            references dbo.DocFiscal,
    Mensagem               varchar(1000)    not null,
    Data                   datetime         not null,
    Tentativas             int              not null,
    JsonEnvio              varchar(max),
    CodigoTabTipoEventoNFe int              not null
        constraint FK_DocFiscalRetorno_TabTipoEventoNFe
            references dbo.TabTipoEventoNFe
);

create index IX_FK_DocFiscalRetorno_DocFiscal1
    on dbo.DocFiscalRetorno (DocFiscalId);

create index IX_FK_DocFiscalRetorno_TabTipoEventoNFe
    on dbo.DocFiscalRetorno (CodigoTabTipoEventoNFe);

create table dbo.LancamentoContabil
(
    LancamentoContabilId          bigint identity
        constraint PK_LancamentoContabil
        primary key,
    CadPlanoContaDetalheDebitoId  int            not null,
    CadPlanoContaDetalheCreditoId int            not null,
    Historico                     nvarchar(255),
    Data                          datetime       not null,
    Valor                         decimal(18, 2) not null,
    Conciliado                    bit            not null,
    ConciliadoData                datetime       not null,
    ContaPagarId                  int
        constraint FK_LancamentoContabil_ContaPagar
            references dbo.ContaPagar,
    ContaPagarBaixaId             int
        constraint FK_LancamentoContabil_ContaPagarBaixa
            references dbo.ContaPagarBaixa,
    ContaReceberId                int
        constraint FK_LancamentoContabil_ContaReceber
            references dbo.ContaReceber,
    ContaReceberBaixaId           int
        constraint FK_LancamentoContabil_ContaReceberBaixa
            references dbo.ContaReceberBaixa,
    BancoCaixaId                  int
        constraint FK_LancamentoContabil_BancoCaixa
            references dbo.BancoCaixa,
    TipoContabil                  char
);

create index IX_FK_LancamentoContabil_BancoCaixa
    on dbo.LancamentoContabil (BancoCaixaId);

create index IX_FK_LancamentoContabil_ContaPagar
    on dbo.LancamentoContabil (ContaPagarId);

create index IX_FK_LancamentoContabil_ContaPagarBaixa
    on dbo.LancamentoContabil (ContaPagarBaixaId);

create index IX_FK_LancamentoContabil_ContaReceber
    on dbo.LancamentoContabil (ContaReceberId);

create index IX_FK_LancamentoContabil_ContaReceberBaixa
    on dbo.LancamentoContabil (ContaReceberBaixaId);

create table dbo.TabUF
(
    CodigoTabUF  nchar(2)     not null
        constraint PK_TabUF
            primary key,
    Nome         nvarchar(20) not null,
    CodigoIbge   nchar(2)     not null,
    DataInicio   datetime     not null,
    DataFim      datetime,
    VersaoUpdate nvarchar(10) not null
);

create table dbo.CadEmpresaEndereco
(
    CadEmpresaEnderecoId       int identity
        constraint PK_CadEmpresaEndereco
        primary key,
    CadAssinanteId             int           not null,
    CadEmpresaId               int           not null
        constraint FK_CadEmpresaEndereco_CadEmpresa
            references dbo.CadEmpresa,
    EnderecoCEP                nchar(8)      not null,
    EnderecoLogradouro         nvarchar(150) not null,
    EnderecoNumero             nvarchar(10)  not null,
    EnderecoComplemento        nvarchar(100) not null,
    EnderecoBairro             nvarchar(60)  not null,
    EnderecoCidade             nvarchar(60)  not null,
    EnderecoCodigoTabUF        nchar(2)      not null
        constraint FK_CadEmpresaEndereco_TabUF
            references dbo.TabUF,
    EnderecoCodigoTabMunicipio nchar(7)      not null,
    EnderecoCodigoTabPais      int           not null
        constraint FK_CadEmpresaEndereco_TabPais
            references dbo.TabPais,
    Principal                  bit           not null,
    IdentificacaoEndereco      nvarchar(20)  not null,
    CadastroData               datetime      not null,
    Inativo                    bit           not null,
    InativoData                datetime      not null
);

create index IX_FK_CadEmpresaEndereco_CadEmpresa
    on dbo.CadEmpresaEndereco (CadEmpresaId);

create index IX_FK_CadEmpresaEndereco_TabPais
    on dbo.CadEmpresaEndereco (EnderecoCodigoTabPais);

create index IX_FK_CadEmpresaEndereco_TabUF
    on dbo.CadEmpresaEndereco (EnderecoCodigoTabUF);

create table dbo.CadParticipanteEndereco
(
    CadParticipanteEnderecoId  int identity
        constraint PK_CadParticipanteEndereco
        primary key,
    CadAssinanteId             int           not null,
    CadParticipanteId          bigint        not null
        constraint FK_CadParticipanteEndereco_CadParticipante
            references dbo.CadParticipante,
    EnderecoCEP                nchar(8)      not null,
    EnderecoLogradouro         nvarchar(150) not null,
    EnderecoNumero             nvarchar(10)  not null,
    EnderecoComplemento        nvarchar(100),
    EnderecoBairro             nvarchar(60)  not null,
    EnderecoCidade             nvarchar(60)  not null,
    EnderecoCodigoTabUF        nchar(2)      not null
        constraint FK_CAD_CadParticipanteEndereco_SIS_TabUF_CodigoTabUF
            references dbo.TabUF,
    EnderecoCodigoTabMunicipio nchar(7)      not null
        constraint FK_CAD_CadParticipanteEndereco_SIS_TabMunicipio_CodigoTabMunicipio
            references dbo.TabMunicipio,
    EnderecoCodigoTabPais      int           not null
        constraint FK_CAD_CadParticipanteEndereco_SIS_TabPais_CodigoTabPais
            references dbo.TabPais,
    Principal                  bit           not null,
    IdentificacaoEndereco      nvarchar(20)  not null,
    CadastroData               datetime      not null,
    Inativo                    bit           not null,
    InativoData                datetime      not null,
    CodigoTabTipoParticipante  nvarchar(20)
        constraint FK_CadParticipanteEndereco_TabTipoParticipante
            references dbo.TabTipoParticipante
);

create index IX_FK_CadParticipanteEndereco_CadParticipante
    on dbo.CadParticipanteEndereco (CadParticipanteId);

create index IX_FK_CAD_CadParticipanteEndereco_SIS_TabMunicipio_CodigoTabMunicipio
    on dbo.CadParticipanteEndereco (EnderecoCodigoTabMunicipio);

create index IX_FK_CAD_CadParticipanteEndereco_SIS_TabPais_CodigoTabPais
    on dbo.CadParticipanteEndereco (EnderecoCodigoTabPais);

create index IX_FK_CAD_CadParticipanteEndereco_SIS_TabUF_CodigoTabUF
    on dbo.CadParticipanteEndereco (EnderecoCodigoTabUF);

create index IX_FK_CadParticipanteEndereco_TabTipoParticipante
    on dbo.CadParticipanteEndereco (CodigoTabTipoParticipante);

create table dbo.DocFiscalArrecReferenciada
(
    DocFiscalId                bigint         not null
        constraint FK_FIS_DocFiscalArrecReferenciada_FIS_DocFiscal_IDDocFiscal
            references dbo.DocFiscal,
    CodigoTabModDocArrecadacao nchar          not null
        constraint FK_FIS_DocFiscalArrecReferenciada_SIS_TabModDocArrecadacao_CodigoTabModDocArrecadacao
            references dbo.TabModDocArrecadacao,
    NumeroDocumento            nvarchar(255)  not null,
    CodigoTabUF                nchar(2)       not null
        constraint FK_FIS_DocFiscalArrecReferenciada_SIS_TabUF_CodigoTabUF
            references dbo.TabUF,
    DataVencimento             datetime       not null,
    DataPagamento              datetime,
    ValorTotal                 decimal(18, 2) not null,
    CodigoAutBancaria          nvarchar(255)  not null,
    CodigoInformacao           nchar(6)       not null,
    DescricaoComplementar      nvarchar(255)  not null,
    constraint PK_DocFiscalArrecReferenciada
        primary key (DocFiscalId, CodigoTabModDocArrecadacao, NumeroDocumento)
);

create index IX_FK_FIS_DocFiscalArrecReferenciada_SIS_TabModDocArrecadacao_CodigoTabModDocArrecadacao
    on dbo.DocFiscalArrecReferenciada (CodigoTabModDocArrecadacao);

create index IX_FK_FIS_DocFiscalArrecReferenciada_SIS_TabUF_CodigoTabUF
    on dbo.DocFiscalArrecReferenciada (CodigoTabUF);

create table dbo.TabUnidadeMedida
(
    CodigoTabUnidadeMedida nvarchar(6)   not null
        constraint PK_TabUnidadeMedida
            primary key,
    Descricao              nvarchar(100) not null,
    DataInicio             datetime      not null,
    DataFim                datetime,
    VersaoUpdate           nvarchar(10)  not null
);

create table dbo.CadItem
(
    CadItemId                   bigint identity
        constraint PK_CadItem
        primary key,
    CadAssinanteId              int            not null,
    CadEmpresaId                int            not null
        constraint FK_CAD_CadItem_CAD_CadEmpresa_CadEmpresaId
            references dbo.CadEmpresa
        constraint FK_CadItem_CadEmpresa
            references dbo.CadEmpresa,
    Codigo                      nvarchar(60)   not null,
    Descricao                   nvarchar(100)  not null,
    CodigoTabItemGrupoId        int            not null
        constraint FK_CadItem_TabItemGrupo
            references dbo.TabItemGrupo,
    CodigoTabNCM                nvarchar(8)
        constraint FK_CadItem_TabNCM
            references dbo.TabNCM,
    CodigoTabNCMExcecaoTIPI     nvarchar(3),
    CodigoTabCEST               nvarchar(7),
    CodigoTabUnidadeMedida      nvarchar(6)    not null
        constraint FK_CAD_CadItem_SIS_TabUnidadeMedida_CodigoTabUnidadeMedida
            references dbo.TabUnidadeMedida,
    CodigoTabTipoItem           int
        constraint FK_CAD_CadItem_SIS_TabTipoItem_CodigoTabTipoItem
            references dbo.TabTipoItem,
    CodigoTabServicoLC116       nvarchar(5)
        constraint FK_CadItem_TabServicoLC116
            references dbo.TabServicoLC116,
    CodigoTabANPCombustivel     nchar(9)       not null
        constraint FK_CAD_CadItem_SIS_TabANPCombustivel_CodigoTabANPCombustivel
            references dbo.TabANPCombustivel,
    CodigoBarras                nvarchar(13)   not null,
    MarcaComercial              nvarchar(60)   not null,
    Linha                       nvarchar(100)  not null,
    PrecoUnitario               decimal(18, 6) not null,
    AliquotaPis                 decimal(18, 6) not null,
    AliquotaCofins              decimal(18, 6) not null,
    AliquotaIpi                 decimal(18, 6) not null,
    AliquotaIcms                decimal(18, 2) not null,
    Volume                      decimal(18, 6) not null,
    PesoBruto                   decimal(18, 6) not null,
    PesoLiquido                 decimal(18, 6) not null,
    Bloqueado                   bit            not null,
    BloqueioData                datetime       not null,
    BloqueioDescricao           nvarchar(100)  not null,
    EstoqueMinimo               decimal(18, 6) not null,
    EstoqueAtual                decimal(18, 6) not null,
    EstoqueMaximo               decimal(18, 6) not null,
    Observacao                  nvarchar(1000) not null,
    CustoMedio                  decimal(18, 6) not null,
    MargemLucro                 decimal(18, 6) not null,
    DescontarUsuProprio         decimal(18, 2) not null,
    DescontarUsuIterno          decimal(18, 2) not null,
    ValorDesconto               decimal(18, 2) not null,
    TabFormaComissaoId          int            not null
        constraint FK_CadItem_TabFormaComissao
            references dbo.TabFormaComissao,
    TabTipoComissaoId           int            not null
        constraint FK_CadItem_TabTipoComissao
            references dbo.TabTipoComissao,
    ValorComissao               decimal(18, 2) not null,
    DescontoMaximoPercentual    decimal(18, 2) not null,
    DescontarUsoCliente         bit            not null,
    CodigoTabItemSubGrupoId     int            not null
        constraint FK_CadItem_TabItemSubGrupo
            references dbo.TabItemSubGrupo,
    DescontarUsoProfissional    bit            not null,
    CadItemFinalidadeId         bigint         not null
        constraint FK_CadItem_CadItemFinalidade
            references dbo.CadItemFinalidade,
    TabTipoComissaoIdAssistente int            not null
        constraint FK_CadItem_TabTipoComissao1
            references dbo.TabTipoComissao,
    ValorComissaoAssistente     decimal(18, 2) not null,
    EstoqueMinimoCompra         decimal(18, 6) not null,
    LucroValor                  decimal(18, 2) not null,
    LucroPercentual             decimal(5, 2)  not null,
    LucroLiquido                decimal(18, 2) not null,
    Created                  datetime       not null,
    UserCreate                  nvarchar(128)  not null,
    Updated                  datetime       not null,
    UserUpdate                  nvarchar(128)  not null,
    FornecedorId                bigint
        constraint FK_CadItem_CadParticipante
            references dbo.CadParticipante,
    TempoEntrega                int            not null,
    Referencia                  nvarchar(128),
    CadItemMetaOrigemId         int,
    CustoUnitario               decimal(10, 2),
    CustoUnitarioICMS           decimal(10, 2),
    Validade                    datetime,
    CustoTotal                  decimal(10, 2),
    CadItemMetaCSTId            int,
    CadItemMetaCSOSNId          int,
    CadItemMetaCESTId           int,
    constraint FK_CadItem_CadMarcaComercial
        foreign key (MarcaComercial, CadEmpresaId) references dbo.CadMarcaComercial
);

create index IX_FK_CAD_CadItem_CAD_CadEmpresa_CadEmpresaId
    on dbo.CadItem (CadEmpresaId);

create index IX_FK_CadItem_CadEmpresa
    on dbo.CadItem (CadEmpresaId);

create index IX_FK_CAD_CadItem_SIS_TabANPCombustivel_CodigoTabANPCombustivel
    on dbo.CadItem (CodigoTabANPCombustivel);

create index IX_FK_CAD_CadItem_SIS_TabTipoItem_CodigoTabTipoItem
    on dbo.CadItem (CodigoTabTipoItem);

create index IX_FK_CAD_CadItem_SIS_TabUnidadeMedida_CodigoTabUnidadeMedida
    on dbo.CadItem (CodigoTabUnidadeMedida);

create index IX_FK_CadItem_CadItemFinalidade
    on dbo.CadItem (CadItemFinalidadeId);

create index IX_FK_CadItem_CadMarcaComercial
    on dbo.CadItem (MarcaComercial, CadEmpresaId);

create index IX_FK_CadItem_CadParticipante
    on dbo.CadItem (FornecedorId);

create index IX_FK_CadItem_TabFormaComissao
    on dbo.CadItem (TabFormaComissaoId);

create index IX_FK_CadItem_TabItemGrupo
    on dbo.CadItem (CodigoTabItemGrupoId);

create index IX_FK_CadItem_TabItemSubGrupo
    on dbo.CadItem (CodigoTabItemSubGrupoId);

create index IX_FK_CadItem_TabNCM
    on dbo.CadItem (CodigoTabNCM);

create index IX_FK_CadItem_TabServicoLC116
    on dbo.CadItem (CodigoTabServicoLC116);

create index IX_FK_CadItem_TabTipoComissao
    on dbo.CadItem (TabTipoComissaoId);

create index IX_FK_CadItem_TabTipoComissao1
    on dbo.CadItem (TabTipoComissaoIdAssistente);

create table dbo.CadItemComissaoPorProfissional
(
    CadItemId         bigint         not null
        constraint FK_CadItemComissaoPorProfissional_CadItem
            references dbo.CadItem,
    CadParticipanteId bigint         not null
        constraint FK_CadItemComissaoPorProfissional_CadParticipante
            references dbo.CadParticipante,
    CadEmpresaId      int            not null
        constraint FK_CadItemComissaoPorProfissional_CadEmpresa
            references dbo.CadEmpresa,
    TabTipoComissaoId int            not null
        constraint FK_CadItemComissaoPorProfissional_TabTipoComissao
            references dbo.TabTipoComissao,
    Valor             decimal(18, 2) not null,
    constraint PK_CadItemComissaoPorProfissional
        primary key (CadItemId, CadParticipanteId, CadEmpresaId)
);

create index IX_FK_CadItemComissaoPorProfissional_CadEmpresa
    on dbo.CadItemComissaoPorProfissional (CadEmpresaId);

create index IX_FK_CadItemComissaoPorProfissional_CadParticipante
    on dbo.CadItemComissaoPorProfissional (CadParticipanteId);

create index IX_FK_CadItemComissaoPorProfissional_TabTipoComissao
    on dbo.CadItemComissaoPorProfissional (TabTipoComissaoId);

create table dbo.CadItemConversao
(
    CadItemConversaoId     int            not null
        constraint PK_CadItemConversao
            primary key,
    CadItemId              bigint         not null,
    CodigoTabUnidadeMedida nvarchar(6)    not null
        constraint FK_CadItemConversao_TabUnidadeMedida
            references dbo.TabUnidadeMedida,
    CadAssinanteId         int            not null,
    CadEmpresaId           int            not null,
    FatorConversao         decimal(18, 6) not null
);

create index IX_FK_CadItemConversao_TabUnidadeMedida
    on dbo.CadItemConversao (CodigoTabUnidadeMedida);

create table dbo.CadItemMovimentacao
(
    CadItemMovId      bigint identity
        constraint PK_CadItemMovimentacao
        primary key,
    CadItemId         bigint         not null
        constraint FK_CadItemMovimentacao_CadItem
            references dbo.CadItem
            on delete cascade,
    Observacao        nvarchar(255)  not null,
    TipoMovimentacao  int            not null,
    Quantidade        decimal(18, 2) not null,
    DataMovimentacao  datetime       not null,
    CadEmpresaId      int            not null,
    UserCreate        nvarchar(255)  not null,
    DataCreate        datetime       not null,
    UserUpdate        nvarchar(255)  not null,
    DataUpdate        datetime       not null,
    NFeFornecedor     nvarchar(128),
    CustoUnitario     decimal(10, 2),
    CustoUnitarioICMS decimal(10, 2),
    Validade          datetime
);

create index IX_FK_CadItemMovimentacao_CadItem
    on dbo.CadItemMovimentacao (CadItemId);

create table dbo.CadItemRegistroSaida
(
    CadItemId                  bigint not null
        constraint PK_CadItemRegistroSaida
            primary key
        constraint FK_CadItemRegistroSaida_CadItem
            references dbo.CadItem,
    CodigoTabCadItemPorUnidade nvarchar(50)
        constraint FK_CadItemRegistroSaida_TabCadItemPorUnidade
            references dbo.TabCadItemPorUnidade,
    Quantidade                 decimal(18, 3),
    CodigoTabUnidadeMedida     nvarchar(6)
        constraint FK_CadItemRegistroSaida_TabUnidadeMedida
            references dbo.TabUnidadeMedida
);

create index IX_FK_CadItemRegistroSaida_TabCadItemPorUnidade
    on dbo.CadItemRegistroSaida (CodigoTabCadItemPorUnidade);

create index IX_FK_CadItemRegistroSaida_TabUnidadeMedida
    on dbo.CadItemRegistroSaida (CodigoTabUnidadeMedida);

create table dbo.CadPacoteItem
(
    CadPacoteId    int            not null
        constraint FK_CadPacoteServicoItem_CadPacote
            references dbo.CadPacote,
    CadPacoteItem1 int identity,
    CadServicoId   int
        constraint FK_CadPacoteServicoItem_CadServico
            references dbo.CadServico,
    CadItemId      bigint
        constraint FK_CadPacoteItem_CadItem
            references dbo.CadItem,
    Tipo           nvarchar(10)   not null,
    Descricao      nvarchar(100)  not null,
    ValorUnitario  decimal(18, 6) not null,
    Quantidade     decimal(18, 6) not null,
    CadAssinanteId int,
    CadEmpresaId   int,
    Desconto       decimal(18, 2),
    constraint PK_CadPacoteItem
        primary key (CadPacoteId, CadPacoteItem1)
);

create index IX_FK_CadPacoteItem_CadItem
    on dbo.CadPacoteItem (CadItemId);

create index IX_FK_CadPacoteServicoItem_CadServico
    on dbo.CadPacoteItem (CadServicoId);

create table dbo.ComandaItem
(
    ComandaItem1               int              not null,
    ComandaId                  uniqueidentifier not null
        constraint FK_ComandaItem_Comanda
            references dbo.Comanda,
    CadServicoId               int
        constraint FK_ComandaItem_CadServico
            references dbo.CadServico,
    CadItemId                  bigint
        constraint FK_ComandaItem_CadItem
            references dbo.CadItem,
    ProfissionalId             bigint
        constraint FK_ComandaItem_CadParticipante
            references dbo.CadParticipante,
    AgendaServicoId            uniqueidentifier
        constraint FK_ComandaItem_AgendaServico
            references dbo.AgendaServico,
    Quantidade                 decimal(18, 3)   not null,
    PrecoUnitario              decimal(18, 2)   not null,
    Desconto                   decimal(18, 2)   not null,
    TotalItem                  decimal(18, 2)   not null,
    BaseCalculoComissao        decimal(18, 2)   not null,
    AliquotaISS                decimal(18, 2)   not null,
    ValorDeducoesISS           decimal(18, 2)   not null,
    ValorISS                   decimal(18, 2)   not null,
    IndicadorISSRetido         bit              not null,
    ValorDescontoIncondicional decimal(18, 2)   not null,
    AliquotaIRRF               decimal(18, 2)   not null,
    IndicadorIRRFRetido        bit              not null,
    AliquotaCSLL               decimal(18, 2)   not null,
    AliquotaPIS                decimal(18, 2)   not null,
    IndicadorPISRetido         bit              not null,
    AliquotaCOFINS             decimal(18, 2)   not null,
    IndicadorCOFINSRetido      bit              not null,
    AliquotaINSS               decimal(18, 2)   not null,
    IndicadorINSSRetido        bit              not null,
    ValorISSEspecificado       bit              not null,
    ValorIRRF                  decimal(18, 2)   not null,
    IndicadorCSLLRetido        bit              not null,
    Excluido                   bit              not null,
    ExcluidoData               datetime,
    ExcluidoUser               nvarchar(128),
    Updated                 datetime         not null,
    UserUpdate                 nvarchar(128)    not null,
    constraint PK_ComandaItem
        primary key (ComandaItem1, ComandaId)
);

create index IX_FK_ComandaItem_AgendaServico
    on dbo.ComandaItem (AgendaServicoId);

create index IX_FK_ComandaItem_CadItem
    on dbo.ComandaItem (CadItemId);

create index IX_FK_ComandaItem_CadParticipante
    on dbo.ComandaItem (ProfissionalId);

create index IX_FK_ComandaItem_CadServico
    on dbo.ComandaItem (CadServicoId);

create index IX_FK_ComandaItem_Comanda
    on dbo.ComandaItem (ComandaId);

create table dbo.ComandaItemAssistente
(
    ComandaItemAssistenteId uniqueidentifier not null
        constraint PK_ComandaItemAssistente
            primary key,
    ComandaId               uniqueidentifier,
    ComandaItem             int,
    AssistenteId            bigint
        constraint FK_ComandaItemAssistente_CadParticipante
            references dbo.CadParticipante,
    constraint FK_ComandaItemAssistente_ComandaItem
        foreign key (ComandaItem, ComandaId) references dbo.ComandaItem
);

create index IX_FK_ComandaItemAssistente_CadParticipante
    on dbo.ComandaItemAssistente (AssistenteId);

create index IX_FK_ComandaItemAssistente_ComandaItem
    on dbo.ComandaItemAssistente (ComandaItem, ComandaId);

create table dbo.ComissaoEvento
(
    ComissaoId              uniqueidentifier not null
        constraint PK_ComissaoEvento
            primary key,
    CadAssinanteId          int              not null
        constraint FK_ComissaoEvento_CadAssinante
            references dbo.CadAssinante,
    CadEmpresaId            int              not null
        constraint FK_ComissaoEvento_CadEmpresa
            references dbo.CadEmpresa,
    CadParticipanteId       bigint           not null
        constraint FK_ComissaoEvento_CadParticipante
            references dbo.CadParticipante,
    DataEvento              datetime         not null,
    DataComissao            datetime         not null,
    GeradoComanda           bit              not null,
    ComandaId               uniqueidentifier
        constraint FK_ComissaoEvento_Comanda
            references dbo.Comanda,
    ComandaItem             int,
    NumeroComanda           nvarchar(20),
    CodigoTabFormaPagamento int
        constraint FK_ComissaoEvento_TabFormaPagamento
            references dbo.TabFormaPagamento,
    FormaPagamentoTaxa      decimal(18, 2)   not null,
    TabComissaoGrupoId      int              not null
        constraint FK_ComissaoEvento_TabComissaoGrupo
            references dbo.TabComissaoGrupo,
    DebitoCredito           varchar          not null,
    CadItemId               bigint,
    CadServicoId            int
        constraint FK_ComissaoEvento_CadServico
            references dbo.CadServico,
    Recorrente              bit              not null,
    RecorrenteDia           int,
    RecorrenteDataTermino   datetime,
    BaseCalculoVenda        decimal(18, 2)   not null,
    BaseCalculoFormaPagto   decimal          not null,
    ParcelaQuantidade       int              not null,
    ParcelaNumero           int              not null,
    ParcelaDias             int              not null,
    BaseCalculoParcela      decimal(18, 2)   not null,
    ComissaoAliquota        decimal(18, 2)   not null,
    ComissaoReferencia      varchar(20)      not null,
    EventoValor             decimal(18, 2)   not null,
    Pago                    bit              not null,
    Historico               varchar(max),
    Observacao              varchar(max),
    DataPagamento           datetime,
    PagamentoComissaoId     bigint
        constraint FK_ComissaoEvento_PagamentoComissao
            references dbo.PagamentoComissao,
    ClienteId               bigint
        constraint FK_ComissaoEvento_CadParticipanteCliente
            references dbo.CadParticipante,
    CustoItem               decimal(18, 2),
    ValorItem               decimal(18, 2),
    constraint FK_ComissaoEvento_ComandaItem
        foreign key (ComandaItem, ComandaId) references dbo.ComandaItem
);

create index IX_FK_ComissaoEvento_CadAssinante
    on dbo.ComissaoEvento (CadAssinanteId);

create index IX_FK_ComissaoEvento_CadEmpresa
    on dbo.ComissaoEvento (CadEmpresaId);

create index IX_FK_ComissaoEvento_CadParticipante
    on dbo.ComissaoEvento (CadParticipanteId);

create index IX_FK_ComissaoEvento_CadParticipanteCliente
    on dbo.ComissaoEvento (ClienteId);

create index IX_FK_ComissaoEvento_CadServico
    on dbo.ComissaoEvento (CadServicoId);

create index IX_FK_ComissaoEvento_Comanda
    on dbo.ComissaoEvento (ComandaId);

create index IX_FK_ComissaoEvento_ComandaItem
    on dbo.ComissaoEvento (ComandaItem, ComandaId);

create index IX_FK_ComissaoEvento_PagamentoComissao
    on dbo.ComissaoEvento (PagamentoComissaoId);

create index IX_FK_ComissaoEvento_TabComissaoGrupo
    on dbo.ComissaoEvento (TabComissaoGrupoId);

create index IX_FK_ComissaoEvento_TabFormaPagamento
    on dbo.ComissaoEvento (CodigoTabFormaPagamento);

create table dbo.DocFiscalItem
(
    DocFiscalItemId            int identity,
    DocFiscalId                bigint         not null
        constraint FK_FIS_DocFiscalItem_FIS_DocFiscal_IDDocFiscal
            references dbo.DocFiscal,
    CadItemId                  bigint,
    Quantidade                 decimal(18, 2) not null,
    CodigoTabUnidadeMedida     nvarchar(6)    not null,
    ValorTotal                 decimal(18, 2) not null,
    ValorDesconto              decimal(18, 2) not null,
    CodigoTabCFOP              nchar(4)       not null
        constraint FK_FIS_DocFiscalItem_SIS_TabCFOP_CodigoTabCFOP
            references dbo.TabCFOP,
    CodigoTabCstIcmsCsosn      nchar(3)       not null
        constraint FK_FIS_DocFiscalItem_SIS_TabCstIcmsCsosn_CodigoTabCstIcmsCsosn
            references dbo.TabCstIcmsCsosn,
    ValorBCICMS                decimal(18, 2) not null,
    AliquotaICMS               decimal(18, 2) not null,
    ValorICMS                  decimal(18, 2) not null,
    ValorBCICMSST              decimal(18, 2) not null,
    AliquotaICMSST             decimal(18, 2) not null,
    ValorICMSST                decimal(18, 2) not null,
    CodigoTabCstIpi            nchar(2)
        constraint FK_FIS_DocFiscalItem_SIS_TabCstIpi_CodigoTabCstIpi
            references dbo.TabCstIpi,
    ValorBCIPI                 decimal(18, 2) not null,
    AliquotaIPI                decimal(18, 2) not null,
    ValorIPI                   decimal(18, 2) not null,
    CodigoTabCstPis            nchar(2)
        constraint FK_FIS_DocFiscalItem_SIS_TabCstPis_CodigoTabCstPis
            references dbo.TabCstPis,
    ValorBCPIS                 decimal(18, 2) not null,
    QuantidadeBCPIS            decimal(18, 2) not null,
    AliquotaPIS                decimal(18, 2) not null,
    AliquotaPISEmReais         decimal(18, 2) not null,
    ValorPIS                   decimal(18, 2) not null,
    CodigoTabCstCofins         nchar(2)
        constraint FK_FIS_DocFiscalItem_SIS_TabCstCofins_CodigoTabCstCofins
            references dbo.TabCstCofins,
    ValorBCCOFINS              decimal(18, 2) not null,
    QuantidadeBCCOFINS         decimal(18, 2) not null,
    AliquotaCOFINS             decimal(18, 2) not null,
    AliquotaCOFINSEmReais      decimal(18, 2) not null,
    ValorCOFINS                decimal(18, 2) not null,
    CodigoTabIndPerApuracaoIPI nchar
        constraint FK_FIS_DocFiscalItem_SIS_TabIndPerApuracaoIPI_CodigoTabIndPerApuracaoIPI
            references dbo.TabIndPerApuracaoIPI,
    CodigoTabEnquadIPI         nvarchar(5)
        constraint FK_FIS_DocFiscalItem_SIS_TabEnquadIPI_CodigoTabEnquadIPI
            references dbo.TabEnquadIPI,
    CodigoContaContabil        nchar(5)       not null,
    ValorBCISSQN               decimal(18, 2) not null,
    AliquotaISSQN              decimal(18, 2) not null,
    ValorISSQN                 decimal(18, 2) not null,
    CodigoTabSeloIPI           nvarchar(6)
        constraint FK_FIS_DocFiscalItem_SIS_TabSeloIPI_CodigoTabSeloIPI
            references dbo.TabSeloIPI,
    SeloIPIQuantidade          int            not null,
    EstoqueAtual               decimal(18, 6) not null,
    DescricaoItem              nvarchar(120)  not null,
    ValorUnitario              decimal(18, 2) not null,
    ComandaItemId              int,
    ComandaId                  uniqueidentifier,
    CodigoItem                 nvarchar(60)   not null,
    constraint PK_DocFiscalItem
        primary key (DocFiscalItemId, DocFiscalId),
    constraint FK_DocFiscalItem_ComandaItem
        foreign key (ComandaItemId, ComandaId) references dbo.ComandaItem
);

create index IX_FK_DocFiscalItem_ComandaItem
    on dbo.DocFiscalItem (ComandaItemId, ComandaId);

create index IX_FK_FIS_DocFiscalItem_FIS_DocFiscal_IDDocFiscal
    on dbo.DocFiscalItem (DocFiscalId);

create index IX_FK_FIS_DocFiscalItem_SIS_TabCFOP_CodigoTabCFOP
    on dbo.DocFiscalItem (CodigoTabCFOP);

create index IX_FK_FIS_DocFiscalItem_SIS_TabCstCofins_CodigoTabCstCofins
    on dbo.DocFiscalItem (CodigoTabCstCofins);

create index IX_FK_FIS_DocFiscalItem_SIS_TabCstIcmsCsosn_CodigoTabCstIcmsCsosn
    on dbo.DocFiscalItem (CodigoTabCstIcmsCsosn);

create index IX_FK_FIS_DocFiscalItem_SIS_TabCstIpi_CodigoTabCstIpi
    on dbo.DocFiscalItem (CodigoTabCstIpi);

create index IX_FK_FIS_DocFiscalItem_SIS_TabCstPis_CodigoTabCstPis
    on dbo.DocFiscalItem (CodigoTabCstPis);

create index IX_FK_FIS_DocFiscalItem_SIS_TabEnquadIPI_CodigoTabEnquadIPI
    on dbo.DocFiscalItem (CodigoTabEnquadIPI);

create index IX_FK_FIS_DocFiscalItem_SIS_TabIndPerApuracaoIPI_CodigoTabIndPerApuracaoIPI
    on dbo.DocFiscalItem (CodigoTabIndPerApuracaoIPI);

create index IX_FK_FIS_DocFiscalItem_SIS_TabSeloIPI_CodigoTabSeloIPI
    on dbo.DocFiscalItem (CodigoTabSeloIPI);

create table dbo.DocFiscalItemLoteMedic
(
    DocFiscalId           bigint         not null,
    DocFiscalItemId       int            not null,
    NumeroLote            nchar(255)     not null,
    DataFabricacao        datetime       not null,
    Quantidade            decimal(18, 2) not null,
    DataValidade          datetime       not null,
    CodigoTabTipoMedic    int            not null
        constraint FK_FIS_DocFiscalItemLoteMedic_SIS_TabTipoMedic_CodigoTabTipoMedic
            references dbo.TabTipoMedic,
    CodigoTabIndICMSMedic int            not null
        constraint FK_FIS_DocFiscalItemLoteMedic_SIS_TabIndICMSMedic_CodigoTabIndICMSMedic
            references dbo.TabIndICMSMedic,
    PrecoTabelado         decimal(18, 2) not null,
    constraint PK_DocFiscalItemLoteMedic
        primary key (DocFiscalId, DocFiscalItemId, NumeroLote, DataFabricacao),
    constraint FK_FIS_DocFiscalItemLoteMedic_FIS_DocFiscalItem_IDDocFiscalItem_IDDocFiscal
        foreign key (DocFiscalItemId, DocFiscalId) references dbo.DocFiscalItem
);

create index IX_FK_FIS_DocFiscalItemLoteMedic_SIS_TabIndICMSMedic_CodigoTabIndICMSMedic
    on dbo.DocFiscalItemLoteMedic (CodigoTabIndICMSMedic);

create index IX_FK_FIS_DocFiscalItemLoteMedic_SIS_TabTipoMedic_CodigoTabTipoMedic
    on dbo.DocFiscalItemLoteMedic (CodigoTabTipoMedic);

create table dbo.DocFiscalItemTanque
(
    DocFiscalId     bigint         not null,
    DocFiscalItemId int            not null,
    NumeroTanque    nchar(3)       not null,
    Quantidade      decimal(18, 2) not null,
    constraint PK_DocFiscalItemTanque
        primary key (DocFiscalId, DocFiscalItemId, NumeroTanque),
    constraint FK_FIS_DocFiscalItemTanque_FIS_DocFiscalItem_IDDocFiscalItem_IDDocFiscal
        foreign key (DocFiscalItemId, DocFiscalId) references dbo.DocFiscalItem
);

create table dbo.DocFiscalItemVeiculo
(
    DocFiscalId        bigint    not null,
    DocFiscalItemId    int       not null,
    ChassiVeiculo      nchar(17) not null,
    CNPJConcessionaria nchar(14) not null,
    CodigoTabUF        nchar(2)  not null
        constraint FK_FIS_DocFiscalItemVeiculo_SIS_TabUF_CodigoTabUF
            references dbo.TabUF,
    constraint PK_DocFiscalItemVeiculo
        primary key (DocFiscalId, DocFiscalItemId, ChassiVeiculo),
    constraint FK_FIS_DocFiscalItemVeiculo_FIS_DocFiscalItem_IDDocFiscalItem_IDDocFiscal
        foreign key (DocFiscalItemId, DocFiscalId) references dbo.DocFiscalItem
);

create index IX_FK_FIS_DocFiscalItemVeiculo_SIS_TabUF_CodigoTabUF
    on dbo.DocFiscalItemVeiculo (CodigoTabUF);

create table dbo.MovimentaEstoque
(
    MovimentaEstoqueId           uniqueidentifier not null
        constraint PK_MovimentaEstoque
            primary key,
    CadItemId                    bigint           not null
        constraint FK_MovimentaEstoque_CadItem
            references dbo.CadItem,
    Documento                    nvarchar(50)     not null,
    DataMovimento                datetime         not null,
    Quantidade                   decimal(18, 3)   not null,
    Custo                        decimal(18, 2)   not null,
    PrazoMedioEntrega            int              not null,
    Observacao                   nvarchar(255),
    RegistrarFinanceiro          bit              not null,
    RegistraProfissional         bit              not null,
    UsoProprioInterno            bit              not null,
    TabTipoMovimentacaoEstoque   nvarchar(50)
        constraint FK_MovimentaEstoque_TabTipoMovimentacaoEstoque
            references dbo.TabTipoMovimentacaoEstoque,
    TabMotivoMovimentacaoEstoque int
        constraint FK__Movimenta__TabMo__04CFADEC
            references dbo.TabMotivoMovimentacaoEstoque,
    DataVencimento               datetime,
    CadEmpresaId                 int              not null,
    CadParticipanteId            bigint,
    CodigoTabTipoParticipante    nvarchar(20),
    ComandaId                    uniqueidentifier
        constraint FK_MovimentaEstoque_Comanda
            references dbo.Comanda,
    constraint FK_MovimentaEstoque_CadParticipanteTipo
        foreign key (CadParticipanteId, CodigoTabTipoParticipante, CadEmpresaId) references dbo.CadParticipanteTipo
);

create index IX_FK_MovimentaEstoque_CadItem
    on dbo.MovimentaEstoque (CadItemId);

create index IX_FK_MovimentaEstoque_CadParticipanteTipo
    on dbo.MovimentaEstoque (CadParticipanteId, CodigoTabTipoParticipante, CadEmpresaId);

create index IX_FK_MovimentaEstoque_Comanda
    on dbo.MovimentaEstoque (ComandaId);

create index IX_FK__Movimenta__TabMo__04CFADEC
    on dbo.MovimentaEstoque (TabMotivoMovimentacaoEstoque);

create index IX_FK_MovimentaEstoque_TabTipoMovimentacaoEstoque
    on dbo.MovimentaEstoque (TabTipoMovimentacaoEstoque);

create table dbo.NotaServico
(
    IDNotaServico                   bigint identity
        constraint PK_NotaServico
        primary key,
    IDCadEmpresa                    int            not null
        constraint FK_NotaServico_CadEmpresa
            references dbo.CadEmpresa,
    CodigoTabServicoTributacao      int
        constraint FK_NotaServico_TabServicoTributacao
            references dbo.TabServicoTributacao,
    DataEmissao                     datetime       not null,
    Serie                           nchar(10),
    NumeroNF                        varchar(20),
    CodigoTabCRT                    bigint
        constraint FK_NotaServico_TabCRT
            references dbo.TabCRT,
    CodigoTabRegimeServico          int
        constraint FK_NotaServico_TabRegimeServico
            references dbo.TabRegimeServico,
    CodigoMunicipioPrestacao        nchar(7)
        constraint FK_NotaServico_TabMunicipio
            references dbo.TabMunicipio,
    IDCadParticipante               bigint
        constraint FK_NotaServico_CadParticipante1
            references dbo.CadParticipante,
    IDCadServico                    int,
    CodigoTabUnidadeMedida          nvarchar(6)
        constraint FK_NotaServico_TabUnidadeMedida
            references dbo.TabUnidadeMedida,
    ValorServico                    decimal(18, 6) not null,
    DiscriminacaoServico            varchar(max),
    ValorBCISS                      decimal(18, 2) not null,
    AliquotaISS                     decimal(18, 2) not null,
    ValorDeducoesISS                decimal(18, 2) not null,
    ValorISS                        decimal(18, 2) not null,
    IndicadorISSRetido              bit            not null,
    ValorDescontoIncondicional      decimal(18, 2) not null,
    ValorBCImpostos                 decimal(18, 2) not null,
    ValorTotalNF                    decimal(18, 2) not null,
    AliquotaIRRF                    decimal(18, 2) not null,
    ValorIRRF                       decimal(18, 2) not null,
    IndicadorIRRFRetido             bit            not null,
    AliquotaCSLL                    decimal(18, 2) not null,
    ValorCSLL                       decimal(18, 2) not null,
    IndicadorCSLLRetido             bit            not null,
    AliquotaPIS                     decimal(18, 2) not null,
    ValorPIS                        decimal(18, 2) not null,
    IndicadorPISRetido              bit            not null,
    AliquotaCOFINS                  decimal(18, 2) not null,
    ValorCOFINS                     decimal(18, 2) not null,
    IndicadorCOFINSRetido           bit            not null,
    AliquotaINSS                    decimal(18, 2) not null,
    ValorINSS                       decimal(18, 2) not null,
    IndicadorINSSRetido             bit            not null,
    CodigoVerificacao               varchar(20),
    AssinaturaDigestValue           varchar(28),
    AssinaturaSignatureValue        varchar(max),
    AssinaturaX509Certificate       varchar(max),
    ProtocoloNumero                 bigint,
    ProtocoloDtRecbto               datetime,
    ValorISSEspecificado            bit,
    NumeroRPS                       varchar(20),
    EmitidoMigrate                  bit,
    AliquotaFederal                 decimal(18, 2),
    CodigoTabSitDocumento           nchar(2)
        constraint FK_NotaServico_TabSitDocumento
            references dbo.TabSitDocumento,
    ComandaId                       uniqueidentifier
        constraint FK_NotaServico_Comanda
            references dbo.Comanda,
    MotivoCancelamento              varchar(255),
    DataUltimaConsulta              datetime,
    LinkDanfe                       nvarchar(255),
    LinkXML                         nvarchar(255),
    LinkRPS                         nvarchar(255),
    DataUltimaAlteracaoSitDocumento datetime
);

create index IX_FK_NotaServico_CadEmpresa
    on dbo.NotaServico (IDCadEmpresa);

create index IX_FK_NotaServico_CadParticipante1
    on dbo.NotaServico (IDCadParticipante);

create index IX_FK_NotaServico_Comanda
    on dbo.NotaServico (ComandaId);

create index IX_FK_NotaServico_TabCRT
    on dbo.NotaServico (CodigoTabCRT);

create index IX_FK_NotaServico_TabMunicipio
    on dbo.NotaServico (CodigoMunicipioPrestacao);

create index IX_FK_NotaServico_TabRegimeServico
    on dbo.NotaServico (CodigoTabRegimeServico);

create index IX_FK_NotaServico_TabServicoTributacao
    on dbo.NotaServico (CodigoTabServicoTributacao);

create index IX_FK_NotaServico_TabSitDocumento
    on dbo.NotaServico (CodigoTabSitDocumento);

create index IX_FK_NotaServico_TabUnidadeMedida
    on dbo.NotaServico (CodigoTabUnidadeMedida);

create table dbo.NotaServicoItem
(
    NotaServicoItemId          bigint identity
        constraint PK_NotaServicoItem
        primary key,
    NotaServicoId              bigint
        constraint FK_NotaServidoItem_NotaServico
            references dbo.NotaServico,
    CadServicoId               int
        constraint FK_NotaServidoItem_CadServico
            references dbo.CadServico,
    CadParticipanteId          bigint
        constraint FK_NotaServicoItem_CadParticipante
            references dbo.CadParticipante,
    Quantidade                 decimal(18, 2),
    PrecoUnitario              decimal(18, 2),
    ValorServico               decimal(18, 2),
    AliquotaISS                decimal(18, 2),
    ValorDeducoesISS           decimal(18, 2),
    ValorISS                   decimal(18, 2),
    IndicadorISSRetido         bit,
    ValorDescontoIncondicional decimal(18, 2),
    AliquotaIRRF               decimal(18, 2),
    IndicadorIRRFRetido        bit,
    AliquotaCSLL               decimal(18, 2),
    AliquotaPIS                decimal(18, 2),
    IndicadorPISRetido         bit,
    AliquotaCOFINS             decimal(18, 2),
    IndicadorCOFINSRetido      bit,
    AliquotaINSS               decimal(18, 2),
    IndicadorINSSRetido        bit,
    ValorISSEspecificado       bit,
    ValorIRRF                  decimal(18, 2),
    IndicadorCSLLRetido        bit,
    CodigoTabServicoLC116      nvarchar(5),
    CodigoMunicipio            nvarchar(20)
);

create index IX_FK_NotaServicoItem_CadParticipante
    on dbo.NotaServicoItem (CadParticipanteId);

create index IX_FK_NotaServidoItem_CadServico
    on dbo.NotaServicoItem (CadServicoId);

create index IX_FK_NotaServidoItem_NotaServico
    on dbo.NotaServicoItem (NotaServicoId);

create table dbo.NotaServicoRetorno
(
    IDNotaServicoRetorno bigint identity
        constraint PK_NotaServicoRetorno
        primary key,
    IDNotaServico        bigint        not null
        constraint FK_NotaServicoRetorno_NotaServico
            references dbo.NotaServico
        constraint FK_NotaServicoRetorno_NotaServico1
            references dbo.NotaServico,
    NumeroRPS            nvarchar(10),
    Mensagem             nvarchar(max),
    XMLEnvioMigrate      nvarchar(max),
    XMLRetornoMigrate    nvarchar(max),
    TentativaEnvio       int,
    IsErro               bit           not null,
    AdmUserId            nvarchar(128) not null
        constraint FK_NotaServicoRetorno_AdmUser
            references dbo.AdmUser,
    CodigoMigrate        nvarchar(10),
    Data                 datetime
);

create index IX_FK_NotaServicoRetorno_AdmUser
    on dbo.NotaServicoRetorno (AdmUserId);

create index IX_FK_NotaServicoRetorno_NotaServico
    on dbo.NotaServicoRetorno (IDNotaServico);

create index IX_FK_NotaServicoRetorno_NotaServico1
    on dbo.NotaServicoRetorno (IDNotaServico);

create table dbo.VendaProduto
(
    VendaProdutoId uniqueidentifier not null
        constraint PK_VendaProduto
            primary key,
    NomeProduto    nvarchar(100),
    Representacao  decimal(18, 2),
    Valor          decimal(18, 2),
    ResumoDiaId    uniqueidentifier
        constraint FK_VendaProduto_ResumoDia
            references dbo.ResumoDia
);

create index IX_FK_VendaProduto_ResumoDia
    on dbo.VendaProduto (ResumoDiaId);

create table dbo.VendaServico
(
    VendaServicoId uniqueidentifier not null
        constraint PK_VendaServico
            primary key,
    NomeServico    nvarchar(100),
    Representacao  decimal(18, 2),
    Valor          decimal(18, 2),
    ResumoDiaId    uniqueidentifier
        constraint FK_VendaServico_ResumoDia
            references dbo.ResumoDia
);

create index IX_FK_VendaServico_ResumoDia
    on dbo.VendaServico (ResumoDiaId);

create table dbo.ViewAcessosUsuarios
(
    CadAssinanteId                int           not null,
    CnpjCpf                       nvarchar(14)  not null,
    NomeFantasia                  nvarchar(100),
    RazaoSocial                   nvarchar(100),
    Setor                         nvarchar(50)  not null,
    StatusCadastroEmpresa         bit,
    EmpresaAtiva                  bit,
    StatusAssinante               bit           not null,
    EmailAdministrador            nvarchar(255) not null,
    DataUltimoAcessoAdministrador datetime,
    StatusAcessoAdministrador     nvarchar(20),
    AppVersaoAdministrador        nvarchar(20),
    DataCriacao                   datetime      not null,
    DataFimTeste                  datetime      not null,
    DataIniContrato               datetime      not null,
    DataFimContrato               datetime      not null,
    CEP                           nvarchar(10),
    Rua                           nvarchar(60),
    Bairro                        nvarchar(60),
    Cidade                        nvarchar(50),
    Estado                        nchar(2),
    Telefone_1                    nvarchar(15),
    Telefone_2                    nvarchar(15),
    Telefone_Assinante            nvarchar(15)  not null,
    CoordenadasEmpresa            varchar(83)   not null,
    CupomIndicacao                varchar(255)  not null,
    TotalProfissionais            int,
    TotalUsuarios                 int,
    TotalUsuariosAtivos           int,
    TotalClientes                 int,
    TotalServicos                 int,
    TotalProdutos                 int,
    constraint PK_ViewAcessosUsuarios
        primary key (CadAssinanteId, CnpjCpf, Setor, StatusAssinante, EmailAdministrador, DataCriacao, DataFimTeste,
                     DataIniContrato, DataFimContrato, Telefone_Assinante, CoordenadasEmpresa, CupomIndicacao)
);

create table dbo.ViewUsuariosSaloes
(
    Id                              nvarchar(128) not null,
    CadAssinanteId                  int           not null,
    Nome                            nvarchar(150),
    CpfCnpj                         nvarchar(14)  not null,
    Ativo                           bit           not null,
    Email                           nvarchar(256),
    EmailConfirmado                 bit           not null,
    Telefone                        nvarchar(max),
    Bloqueado                       bit           not null,
    QtdFalhasAcesso                 int           not null,
    NomeUsuario                     nvarchar(256) not null,
    UltimoAcesso                    datetime,
    StatusAcesso                    nvarchar(20),
    Versao                          nvarchar(20),
    NomeFantasia                    nvarchar(100),
    RazaoSocial                     nvarchar(100),
    Empresa___StatusCadastroEmpresa bit,
    EmpresaAtiva                    bit,
    constraint PK_ViewUsuariosSaloes
        primary key (Id, CadAssinanteId, CpfCnpj, Ativo, EmailConfirmado, Bloqueado, QtdFalhasAcesso, NomeUsuario)
);

create table dbo.sysdiagrams
(
    name         nvarchar(128) not null,
    principal_id int           not null,
    diagram_id   int identity
        constraint PK_sysdiagrams
        primary key,
    version      int,
    definition   varbinary(max)
);


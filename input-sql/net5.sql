create table "DiscountPercentageReferrals"
(
    "Id"          varchar(36)       not null
        constraint "PK_DiscountPercentageReferrals"
            primary key,
    "Discount"    integer           not null,
    "DBStatus"    integer default 0 not null,
    "Created"     timestamp         not null,
    "LastUpdated" timestamp         not null,
    "Description" varchar(2560)
)
    using ???;

alter table "DiscountPercentageReferrals"
    owner to postgres;

create table "Coupons"
(
    "Id"                           varchar(36)       not null
        constraint "PK_Coupons"
            primary key,
    "UserId"                       varchar(36)       not null
        constraint "FK_Coupons_AspNetUsers_UserId"
            references "AspNetUsers",
    "Title"                        varchar(30)       not null,
    "DBStatus"                     integer default 0 not null,
    "Created"                      date              not null,
    "LastUpdated"                  timestamp         not null,
    "DiscountPercentageReferralId" varchar(36)
        constraint "FK_Coupons_DiscountPercentageReferrals_DiscountPercentageRefer~"
            references "DiscountPercentageReferrals"
)
    using ???;

alter table "Coupons"
    owner to postgres;

create index "IX_Coupons_UserId"
    on "Coupons" using ??? ("UserId");

create index "IX_Coupons_DiscountPercentageReferralId"
    on "Coupons" using ??? ("DiscountPercentageReferralId");

create table "RedeemedCoupons"
(
    "Id"                    varchar(36)       not null
        constraint "PK_RedeemedCoupons"
            primary key,
    "CouponId"              varchar(36)       not null
        constraint "FK_RedeemedCoupons_Coupons_CouponId"
            references "Coupons",
    "EstablishmentName"     varchar(128)      not null,
    "EstablishmentEmail"    varchar(128)      not null,
    "EstablishmentDocument" varchar(14)       not null,
    "DBStatus"              integer default 0 not null,
    "Created"               date              not null,
    "LastUpdated"           timestamp         not null
)
    using ???;

alter table "RedeemedCoupons"
    owner to postgres;

create index "IX_RedeemedCoupons_CouponId"
    on "RedeemedCoupons" using ??? ("CouponId");

create table "Plans"
(
    "Id"          varchar(36)           not null
        constraint "PK_Plans"
            primary key,
    "Name"        varchar(128)          not null,
    "Description" varchar(512)          not null,
    "Price"       numeric               not null,
    "QtyUsers"    varchar(128)          not null,
    "HasTrial"    boolean               not null,
    "TrialDays"   integer               not null,
    "DBStatus"    integer default 0     not null,
    "Created"     date                  not null,
    "LastUpdated" timestamp             not null,
    "Default"     boolean default false not null
)
    using ???;

alter table "Plans"
    owner to postgres;

create table "DiscountPlans"
(
    "Id"                           varchar(36)       not null
        constraint "PK_DiscountPlans"
            primary key,
    "DiscountPercentageReferralId" varchar(36)       not null
        constraint "FK_DiscountPlans_DiscountPercentageReferrals_DiscountPercentag~"
            references "DiscountPercentageReferrals",
    "PlanId"                       varchar(36)       not null
        constraint "FK_DiscountPlans_Plans_PlanId"
            references "Plans",
    "DateInit"                     timestamp         not null,
    "DateEnd"                      timestamp         not null,
    "DBStatus"                     integer default 0 not null,
    "Created"                      date              not null,
    "LastUpdated"                  timestamp         not null
)
    using ???;

alter table "DiscountPlans"
    owner to postgres;

create index "IX_DiscountPlans_DiscountPercentageReferralId"
    on "DiscountPlans" using ??? ("DiscountPercentageReferralId");

create index "IX_DiscountPlans_PlanId"
    on "DiscountPlans" using ??? ("PlanId");

create table "SubscriberSubscriptions"
(
    "CurrentPlanId"           varchar(36)                               not null
        constraint "FK_SubscriberSubscriptions_Plans_CurrentPlanId"
            references "Plans",
    "GrossPlanValue"          numeric(18, 2)                            not null,
    "PlanDiscountValue"       numeric(18, 2)                            not null,
    "SubscriptionStartDate"   date                                      not null,
    "BaseDaySubscription"     date                                      not null,
    "SubscriptionStatus"      varchar(2560)                             not null,
    "SubscriptionEndDate"     date                                      not null,
    "NumberOfDaysLate"        integer                                   not null,
    "SubscriptionSpecificity" varchar(2560)                             not null,
    "Id"                      varchar(36) default ''::character varying not null
        constraint "PK_SubscriberSubscriptions"
        primary key,
    "DBStatus"                integer     default 0                     not null,
    "Created"                 timestamp                                 not null,
    "LastUpdated"             timestamp                                 not null,
    "Document"                varchar(36) default ''::character varying not null
)
    using ???;

alter table "SubscriberSubscriptions"
    owner to postgres;

create index "IX_SubscriberSubscriptions_CurrentPlanId"
    on "SubscriberSubscriptions" using ??? ("CurrentPlanId");

create table "Auditorias"
(
    "Id"                   varchar(36)              not null
        constraint "PK_Auditorias"
            primary key,
    "Origem"               varchar(2560)            not null,
    "Acao"                 varchar(2560)            not null,
    "Tipo"                 varchar(2560)            not null,
    "DadosProcessados"     varchar(2560),
    "RetornoProcessamento" varchar(2560),
    "Data"                 timestamp with time zone not null,
    "UsuarioAtualizacao"   varchar(2560),
    "DBStatus"             integer default 0        not null,
    "Created"              timestamp                not null,
    "LastUpdated"          timestamp                not null
)
    using ???;

alter table "Auditorias"
    owner to postgres;

create table "DadosBancarios"
(
    "Id"            varchar(36)       not null
        constraint "PK_DadosBancarios"
            primary key,
    "TitularConta"  varchar(2560)     not null,
    "TipoConta"     varchar(2560)     not null,
    "NumeroAgencia" varchar(2560)     not null,
    "NumeroConta"   varchar(2560)     not null,
    "Banco"         varchar(2560)     not null,
    "CodigoBanco"   varchar(2560)     not null,
    "CpfTitular"    varchar(2560)     not null,
    "CnpjBanco"     varchar(2560)     not null,
    "DBStatus"      integer default 0 not null,
    "Created"       timestamp         not null,
    "LastUpdated"   timestamp         not null
)
    using ???;

alter table "DadosBancarios"
    owner to postgres;

create table "Enderecos"
(
    "Id"          varchar(36)       not null
        constraint "PK_Enderecos"
            primary key,
    "Logradouro"  varchar(2560)     not null,
    "Numero"      integer           not null,
    "Complemento" varchar(2560),
    "Bairro"      varchar(2560)     not null,
    "Cidade"      varchar(2560)     not null,
    "Estado"      varchar(2560)     not null,
    "Cep"         varchar(2560)     not null,
    "Pais"        varchar(2560)     not null,
    "Latitude"    real,
    "Longitude"   real,
    "DBStatus"    integer default 0 not null,
    "Created"     timestamp         not null,
    "LastUpdated" timestamp         not null
)
    using ???;

alter table "Enderecos"
    owner to postgres;

create table "HomologacoesFluxos"
(
    "Id"                       varchar(36)       not null
        constraint "PK_HomologacoesFluxos"
            primary key,
    "Nome"                     varchar(2560)     not null,
    "Versao"                   varchar(2560)     not null,
    "FluxoAtivo"               boolean           not null,
    "Descricao"                varchar(2560),
    "Cnpj"                     varchar(2560),
    "SindicatosParticipantes"  varchar(2560),
    "OutrosParticipantes"      varchar(2560),
    "RegioesFluxo"             varchar(2560),
    "ModelosDocumentoFluxo"    varchar(2560),
    "DadosVariaveisDocumentos" varchar(2560),
    "UsuarioAtualizacao"       varchar(2560),
    "DBStatus"                 integer default 0 not null,
    "Created"                  timestamp         not null,
    "LastUpdated"              timestamp         not null
)
    using ???;

alter table "HomologacoesFluxos"
    owner to postgres;

create table "HomologacoesRegioes"
(
    "Id"                varchar(36)       not null
        constraint "PK_HomologacoesRegioes"
            primary key,
    "Nome"              varchar(2560)     not null,
    "Descricao"         varchar(2560),
    "ReferenciaLatLong" varchar(2560),
    "ReferenciaCep"     varchar(2560),
    "Distancia"         double precision  not null,
    "Bairro"            varchar(2560),
    "Regiao"            varchar(2560),
    "Cidade"            varchar(2560),
    "Estado"            varchar(2560),
    "DBStatus"          integer default 0 not null,
    "Created"           timestamp         not null,
    "LastUpdated"       timestamp         not null
)
    using ???;

alter table "HomologacoesRegioes"
    owner to postgres;

create table "Sindicatos"
(
    "Id"                         varchar(36)       not null
        constraint "PK_Sindicatos"
            primary key,
    "Cnpj"                       varchar(2560)     not null,
    "RazaoSocial"                varchar(2560)     not null,
    "NomeFantasia"               varchar(2560)     not null,
    "Sigla"                      varchar(2560)     not null,
    "TipoSindicato"              varchar(2560)     not null,
    "DataAbertura"               varchar(2560)     not null,
    "IdEndereco"                 varchar(36)       not null,
    "TelefonePrincipal"          varchar(2560)     not null,
    "TelefoneSecundario"         varchar(2560)     not null,
    "TelefoneMensagemPrincipal"  varchar(2560)     not null,
    "TelefoneMensagemSecundario" varchar(2560)     not null,
    "EmailPrincipal"             varchar(2560)     not null,
    "EmailSecundario"            varchar(2560)     not null,
    "TipoEmpresa"                varchar(2560)     not null,
    "IdDadosBancarios"           varchar(36)       not null,
    "IdParticipante"             varchar(36)       not null,
    "EnderecoId"                 varchar(36)
        constraint "FK_Sindicatos_Enderecos_EnderecoId"
            references "Enderecos",
    "DadosBancariosId"           varchar(36)
        constraint "FK_Sindicatos_DadosBancarios_DadosBancariosId"
            references "DadosBancarios",
    "DBStatus"                   integer default 0 not null,
    "Created"                    timestamp         not null,
    "LastUpdated"                timestamp         not null
)
    using ???;

alter table "Sindicatos"
    owner to postgres;

create index "IX_Sindicatos_DadosBancariosId"
    on "Sindicatos" using ??? ("DadosBancariosId");

create index "IX_Sindicatos_EnderecoId"
    on "Sindicatos" using ??? ("EnderecoId");

create table "Homologacoes"
(
    "Id"            varchar(36)       not null
        constraint "PK_Homologacoes"
            primary key,
    "Descricao"     varchar(2560),
    "StatusHomolog" integer           not null,
    "IdFluxo"       varchar(36)
        constraint "FK_Homologacoes_HomologacoesFluxos_IdFluxo"
            references "HomologacoesFluxos",
    "DBStatus"      integer default 0 not null,
    "Created"       timestamp         not null,
    "LastUpdated"   timestamp         not null
)
    using ???;

alter table "Homologacoes"
    owner to postgres;

create index "IX_Homologacoes_IdFluxo"
    on "Homologacoes" using ??? ("IdFluxo");

create table "SindicatosHomologacoesRegiao"
(
    "Id"                   varchar(36)       not null
        constraint "PK_SindicatosHomologacoesRegiao"
            primary key,
    "Cnpj"                 varchar(2560),
    "IdHomologacaoRegiao"  varchar(2560),
    "HomologacoesRegiaoId" varchar(36)
        constraint "FK_SindicatosHomologacoesRegiao_HomologacoesRegioes_Homologaco~"
            references "HomologacoesRegioes",
    "DBStatus"             integer default 0 not null,
    "Created"              timestamp         not null,
    "LastUpdated"          timestamp         not null
);

create table "Participantes"
(
    "Id"                         varchar(36)       not null
        constraint "PK_Participantes"
            primary key,
    "IdUsuario"                  varchar(36)       not null,
    "IdSindicato"                varchar(2560)
        constraint "FK_Participantes_Sindicatos_IdSindicato"
            references "Sindicatos"
            on delete restrict,
    "IdEstabelecimento"          varchar(2560),
    "IdProfissional"             varchar(2560),
    "Nome"                       varchar(2560)     not null,
    "CargoFuncao"                varchar(2560),
    "Observacao"                 varchar(2560),
    "Tipo"                       varchar(2560),
    "Cpf"                        varchar(2560),
    "DocumentoIdentificacao"     varchar(2560),
    "DocumentoTipo"              varchar(2560),
    "DocumentoOrgaoEmissor"      varchar(2560),
    "DocumentoDataEmissao"       varchar(2560),
    "DocumentoDataValidade"      varchar(2560),
    "TelefonePrincipal"          varchar(2560),
    "TelefoneSecundario"         varchar(2560),
    "TelefoneMensagemPrincipal"  varchar(2560),
    "TelefoneMensagemSecundario" varchar(2560),
    "EmailPrincipal"             varchar(2560),
    "EmailSecundario"            varchar(2560),
    "IdEndereco"                 varchar(2560)
        constraint "FK_Participantes_Enderecos_IdEndereco"
            references "Enderecos"
            on delete restrict,
    "IdDadosBancarios"           varchar(2560)
        constraint "FK_Participantes_DadosBancarios_IdDadosBancarios"
            references "DadosBancarios"
            on delete restrict,
    "DBStatus"                   integer default 0 not null,
    "Created"                    timestamp         not null,
    "LastUpdated"                timestamp         not null
)
    using ???;

create table "HomologacoesCobrancas"
(
    "Id"                       varchar(36)       not null
        constraint "PK_HomologacoesCobrancas"
            primary key,
    "IdHomologacao"            varchar(36)
        constraint "FK_HomologacoesCobrancas_Homologacoes_IdHomologacao"
            references "Homologacoes"
            on delete restrict,
    "IdSindicato"              varchar(36)
        constraint "FK_HomologacoesCobrancas_Sindicatos_IdSindicato"
            references "Sindicatos"
            on delete restrict,
    "IdParticipante"           varchar(36)
        constraint "FK_HomologacoesCobrancas_Participantes_IdParticipante"
            references "Participantes"
            on delete restrict,
    "ValorCobranca"            numeric           not null,
    "Periodicidade"            varchar(2560),
    "DiaCobranca"              integer,
    "MesCobranca"              integer,
    "AnoCobranca"              integer,
    "StatusCobranca"           varchar(2560),
    "FormatoCobranca"          varchar(2560),
    "ObservacaoCobranca"       varchar(2560),
    "DataConfirmacaoPagamento" timestamp with time zone,
    "DBStatus"                 integer default 0 not null,
    "Created"                  timestamp         not null,
    "LastUpdated"              timestamp         not null
);

create table "HomologacoesDocumentos"
(
    "Id"               varchar(36)       not null
        constraint "PK_HomologacoesDocumentos"
            primary key,
    "IdHomologacao"    varchar(36)
        constraint "FK_HomologacoesDocumentos_Homologacoes_IdHomologacao"
            references "Homologacoes"
            on delete restrict,
    "IdSindicato"      varchar(36)
        constraint "FK_HomologacoesDocumentos_Sindicatos_IdSindicato"
            references "Sindicatos"
            on delete restrict,
    "IdParticipante"   varchar(36)
        constraint "FK_HomologacoesDocumentos_Participantes_IdParticipante"
            references "Participantes"
            on delete restrict,
    "IdDocumento"      varchar(2560),
    "TipoDocumento"    varchar(2560),
    "StatusAssinatura" varchar(2560),
    "DBStatus"         integer default 0 not null,
    "Created"          timestamp         not null,
    "LastUpdated"      timestamp         not null
);

create table "HomologacoesParticipantes"
(
    "Id"                                varchar(36)       not null
        constraint "PK_HomologacoesParticipantes"
            primary key,
    "IdHomologacao"                     varchar(2560)
        constraint "FK_HomologacoesParticipantes_Homologacoes_IdHomologacao"
            references "Homologacoes"
            on delete restrict,
    "IdSindicato"                       varchar(2560)
        constraint "FK_HomologacoesParticipantes_Sindicatos_IdSindicato"
            references "Sindicatos"
            on delete restrict,
    "IdParticipante"                    varchar(2560)
        constraint "FK_HomologacoesParticipantes_Participantes_IdParticipante"
            references "Participantes"
            on delete restrict,
    "TipoPapel"                         varchar(2560),
    "IdReferenciaEstabelecimentoLollol" varchar(2560),
    "IdReferenciaProfissionalLollol"    varchar(2560),
    "ValorParticipante"                 numeric,
    "ObrigatoriedadeAssinatura"         boolean,
    "OrdemAssinatura"                   integer,
    "RecebeNotificacao"                 boolean,
    "Observacao"                        varchar(2560),
    "DBStatus"                          integer default 0 not null,
    "Created"                           timestamp         not null,
    "LastUpdated"                       timestamp         not null
);


create table "DadosBancarios"
(
    "Id"            varchar(36)       not null
        constraint "PK_DadosBancarios"
            primary key,
    "TitularConta"  varchar(2560)     not null,
    "TipoConta"     varchar(2560)     not null,
    "NumeroAgencia" varchar(2560)     not null,
    "NumeroConta"   varchar(2560)     not null,
    "Banco"         varchar(2560)     not null,
    "CodigoBanco"   varchar(2560)     not null,
    "CpfTitular"    varchar(2560)     not null,
    "CnpjBanco"     varchar(2560)     not null,
    "DBStatus"      integer default 0 not null,
    "Created"       timestamp         not null,
    "LastUpdated"   timestamp         not null
);

create table "Enderecos"
(
    "Id"          varchar(36)       not null
        constraint "PK_Enderecos"
            primary key,
    "Logradouro"  varchar(2560)     not null,
    "Numero"      integer           not null,
    "Complemento" varchar(2560),
    "Bairro"      varchar(2560)     not null,
    "Cidade"      varchar(2560)     not null,
    "Estado"      varchar(2560)     not null,
    "Cep"         varchar(2560)     not null,
    "Pais"        varchar(2560)     not null,
    "Latitude"    real,
    "Longitude"   real,
    "DBStatus"    integer default 0 not null,
    "Created"     timestamp         not null,
    "LastUpdated" timestamp         not null
);

create table "HomologacoesFluxos"
(
    "Id"                       varchar(36)       not null
        constraint "PK_HomologacoesFluxos"
            primary key,
    "Nome"                     varchar(2560)     not null,
    "Versao"                   varchar(2560)     not null,
    "FluxoAtivo"               boolean           not null,
    "Descricao"                varchar(2560),
    "Cnpj"                     varchar(2560),
    "SindicatosParticipantes"  varchar(2560),
    "OutrosParticipantes"      varchar(2560),
    "RegioesFluxo"             varchar(2560),
    "ModelosDocumentoFluxo"    varchar(2560),
    "DadosVariaveisDocumentos" varchar(2560),
    "UsuarioAtualizacao"       varchar(2560),
    "DBStatus"                 integer default 0 not null,
    "Created"                  timestamp         not null,
    "LastUpdated"              timestamp         not null
);

create table "Sindicatos"
(
    "Id"                         varchar(36)       not null
        constraint "PK_Sindicatos"
            primary key,
    "Cnpj"                       varchar(2560)     not null,
    "RazaoSocial"                varchar(2560)     not null,
    "NomeFantasia"               varchar(2560)     not null,
    "Sigla"                      varchar(2560)     not null,
    "TipoSindicato"              varchar(2560)     not null,
    "DataAbertura"               varchar(2560)     not null,
    "IdEndereco"                 varchar(36)       not null,
    "TelefonePrincipal"          varchar(2560)     not null,
    "TelefoneSecundario"         varchar(2560)     not null,
    "TelefoneMensagemPrincipal"  varchar(2560)     not null,
    "TelefoneMensagemSecundario" varchar(2560)     not null,
    "EmailPrincipal"             varchar(2560)     not null,
    "EmailSecundario"            varchar(2560)     not null,
    "TipoEmpresa"                varchar(2560)     not null,
    "IdDadosBancarios"           varchar(36)       not null,
    "IdParticipante"             varchar(36)       not null,
    "EnderecoId"                 varchar(36)
        constraint "FK_Sindicatos_Enderecos_EnderecoId"
            references "Enderecos",
    "DadosBancariosId"           varchar(36)
        constraint "FK_Sindicatos_DadosBancarios_DadosBancariosId"
            references "DadosBancarios",
    "DBStatus"                   integer default 0 not null,
    "Created"                    timestamp         not null,
    "LastUpdated"                timestamp         not null
);


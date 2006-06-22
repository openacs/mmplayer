
create table mmplayer_items (
    community_id                integer
                                primary key
                                not null,
    url                         varchar(1000),
    title                       varchar(200),    
    comment                     varchar(500),
    enabled_p                   char(1)
                                default 't'
                                not null
                                check (enabled_p in ('t','f')),
    width                       integer default 320,
    height                      integer default 240,
    begin_date                  timestamptz default current_timestamp not null,
    end_date                    timestamptz default current_timestamp + interval '7 days' not null
);


--
\i mmplayer-sc-create.sql

prompt --application/shared_components/user_interface/template_options
begin
--   Manifest
--     THEME OPTIONS: 100
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88289682661008775)
,p_theme_id=>42
,p_name=>'FBM_LARGE'
,p_display_name=>'Large'
,p_display_sequence=>40
,p_css_classes=>'margin-bottom-lg'
,p_group_id=>wwv_flow_api.id(88235785211008759)
,p_template_types=>'FIELD'
,p_help_text=>'Adds a large bottom margin for this field.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88290433537008776)
,p_theme_id=>42
,p_name=>'RBM_LARGE'
,p_display_name=>'Large'
,p_display_sequence=>40
,p_css_classes=>'margin-bottom-lg'
,p_group_id=>wwv_flow_api.id(88256568722008764)
,p_template_types=>'REGION'
,p_help_text=>'Adds a large bottom margin to the region.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88291097221008776)
,p_theme_id=>42
,p_name=>'FBM_MEDIUM'
,p_display_name=>'Medium'
,p_display_sequence=>30
,p_css_classes=>'margin-bottom-md'
,p_group_id=>wwv_flow_api.id(88235785211008759)
,p_template_types=>'FIELD'
,p_help_text=>'Adds a medium bottom margin for this field.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88291817488008776)
,p_theme_id=>42
,p_name=>'RBM_MEDIUM'
,p_display_name=>'Medium'
,p_display_sequence=>30
,p_css_classes=>'margin-bottom-md'
,p_group_id=>wwv_flow_api.id(88256568722008764)
,p_template_types=>'REGION'
,p_help_text=>'Adds a medium bottom margin to the region.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88292494066008776)
,p_theme_id=>42
,p_name=>'FBM_NONE'
,p_display_name=>'None'
,p_display_sequence=>10
,p_css_classes=>'margin-bottom-none'
,p_group_id=>wwv_flow_api.id(88235785211008759)
,p_template_types=>'FIELD'
,p_help_text=>'Removes the bottom margin for this field.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88293186795008777)
,p_theme_id=>42
,p_name=>'RBM_NONE'
,p_display_name=>'None'
,p_display_sequence=>10
,p_css_classes=>'margin-bottom-none'
,p_group_id=>wwv_flow_api.id(88256568722008764)
,p_template_types=>'REGION'
,p_help_text=>'Removes the bottom margin for this region.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88293904484008777)
,p_theme_id=>42
,p_name=>'FBM_SMALL'
,p_display_name=>'Small'
,p_display_sequence=>20
,p_css_classes=>'margin-bottom-sm'
,p_group_id=>wwv_flow_api.id(88235785211008759)
,p_template_types=>'FIELD'
,p_help_text=>'Adds a small bottom margin for this field.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88294560544008777)
,p_theme_id=>42
,p_name=>'RBM_SMALL'
,p_display_name=>'Small'
,p_display_sequence=>20
,p_css_classes=>'margin-bottom-sm'
,p_group_id=>wwv_flow_api.id(88256568722008764)
,p_template_types=>'REGION'
,p_help_text=>'Adds a small bottom margin to the region.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88295341637008777)
,p_theme_id=>42
,p_name=>'FLM_LARGE'
,p_display_name=>'Large'
,p_display_sequence=>40
,p_css_classes=>'margin-left-lg'
,p_group_id=>wwv_flow_api.id(88237036125008759)
,p_template_types=>'FIELD'
,p_help_text=>'Adds a large left margin for this field.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88296009334008777)
,p_theme_id=>42
,p_name=>'RLM_LARGE'
,p_display_name=>'Large'
,p_display_sequence=>40
,p_css_classes=>'margin-left-lg'
,p_group_id=>wwv_flow_api.id(88256971976008764)
,p_template_types=>'REGION'
,p_help_text=>'Adds a large right margin to the region.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88296720224008778)
,p_theme_id=>42
,p_name=>'FLM_MEDIUM'
,p_display_name=>'Medium'
,p_display_sequence=>30
,p_css_classes=>'margin-left-md'
,p_group_id=>wwv_flow_api.id(88237036125008759)
,p_template_types=>'FIELD'
,p_help_text=>'Adds a medium left margin for this field.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88297387697008778)
,p_theme_id=>42
,p_name=>'RLM_MEDIUM'
,p_display_name=>'Medium'
,p_display_sequence=>30
,p_css_classes=>'margin-left-md'
,p_group_id=>wwv_flow_api.id(88256971976008764)
,p_template_types=>'REGION'
,p_help_text=>'Adds a medium right margin to the region.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88298120446008778)
,p_theme_id=>42
,p_name=>'FLM_NONE'
,p_display_name=>'None'
,p_display_sequence=>10
,p_css_classes=>'margin-left-none'
,p_group_id=>wwv_flow_api.id(88237036125008759)
,p_template_types=>'FIELD'
,p_help_text=>'Removes the left margin for this field.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88298840693008778)
,p_theme_id=>42
,p_name=>'RLM_NONE'
,p_display_name=>'None'
,p_display_sequence=>10
,p_css_classes=>'margin-left-none'
,p_group_id=>wwv_flow_api.id(88256971976008764)
,p_template_types=>'REGION'
,p_help_text=>'Removes the left margin from the region.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88299459994008779)
,p_theme_id=>42
,p_name=>'FLM_SMALL'
,p_display_name=>'Small'
,p_display_sequence=>20
,p_css_classes=>'margin-left-sm'
,p_group_id=>wwv_flow_api.id(88237036125008759)
,p_template_types=>'FIELD'
,p_help_text=>'Adds a small left margin for this field.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88300224769008779)
,p_theme_id=>42
,p_name=>'RLM_SMALL'
,p_display_name=>'Small'
,p_display_sequence=>20
,p_css_classes=>'margin-left-sm'
,p_group_id=>wwv_flow_api.id(88256971976008764)
,p_template_types=>'REGION'
,p_help_text=>'Adds a small left margin to the region.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88300900937008779)
,p_theme_id=>42
,p_name=>'FRM_LARGE'
,p_display_name=>'Large'
,p_display_sequence=>40
,p_css_classes=>'margin-right-lg'
,p_group_id=>wwv_flow_api.id(88238247493008760)
,p_template_types=>'FIELD'
,p_help_text=>'Adds a large right margin for this field.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88301588691008779)
,p_theme_id=>42
,p_name=>'RRM_LARGE'
,p_display_name=>'Large'
,p_display_sequence=>40
,p_css_classes=>'margin-right-lg'
,p_group_id=>wwv_flow_api.id(88257416054008765)
,p_template_types=>'REGION'
,p_help_text=>'Adds a large right margin to the region.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88302323040008779)
,p_theme_id=>42
,p_name=>'FRM_MEDIUM'
,p_display_name=>'Medium'
,p_display_sequence=>30
,p_css_classes=>'margin-right-md'
,p_group_id=>wwv_flow_api.id(88238247493008760)
,p_template_types=>'FIELD'
,p_help_text=>'Adds a medium right margin for this field.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88303013204008780)
,p_theme_id=>42
,p_name=>'RRM_MEDIUM'
,p_display_name=>'Medium'
,p_display_sequence=>30
,p_css_classes=>'margin-right-md'
,p_group_id=>wwv_flow_api.id(88257416054008765)
,p_template_types=>'REGION'
,p_help_text=>'Adds a medium right margin to the region.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88303739721008780)
,p_theme_id=>42
,p_name=>'FRM_NONE'
,p_display_name=>'None'
,p_display_sequence=>10
,p_css_classes=>'margin-right-none'
,p_group_id=>wwv_flow_api.id(88238247493008760)
,p_template_types=>'FIELD'
,p_help_text=>'Removes the right margin for this field.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88304437657008780)
,p_theme_id=>42
,p_name=>'RRM_NONE'
,p_display_name=>'None'
,p_display_sequence=>10
,p_css_classes=>'margin-right-none'
,p_group_id=>wwv_flow_api.id(88257416054008765)
,p_template_types=>'REGION'
,p_help_text=>'Removes the right margin from the region.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88305136803008780)
,p_theme_id=>42
,p_name=>'FRM_SMALL'
,p_display_name=>'Small'
,p_display_sequence=>20
,p_css_classes=>'margin-right-sm'
,p_group_id=>wwv_flow_api.id(88238247493008760)
,p_template_types=>'FIELD'
,p_help_text=>'Adds a small right margin for this field.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88305781701008780)
,p_theme_id=>42
,p_name=>'RRM_SMALL'
,p_display_name=>'Small'
,p_display_sequence=>20
,p_css_classes=>'margin-right-sm'
,p_group_id=>wwv_flow_api.id(88257416054008765)
,p_template_types=>'REGION'
,p_help_text=>'Adds a small right margin to the region.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88306466177008781)
,p_theme_id=>42
,p_name=>'FTM_LARGE'
,p_display_name=>'Large'
,p_display_sequence=>40
,p_css_classes=>'margin-top-lg'
,p_group_id=>wwv_flow_api.id(88239047060008760)
,p_template_types=>'FIELD'
,p_help_text=>'Adds a large top margin for this field.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88307172654008781)
,p_theme_id=>42
,p_name=>'RTM_LARGE'
,p_display_name=>'Large'
,p_display_sequence=>40
,p_css_classes=>'margin-top-lg'
,p_group_id=>wwv_flow_api.id(88258166595008765)
,p_template_types=>'REGION'
,p_help_text=>'Adds a large top margin to the region.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88307938776008781)
,p_theme_id=>42
,p_name=>'FTM_MEDIUM'
,p_display_name=>'Medium'
,p_display_sequence=>30
,p_css_classes=>'margin-top-md'
,p_group_id=>wwv_flow_api.id(88239047060008760)
,p_template_types=>'FIELD'
,p_help_text=>'Adds a medium top margin for this field.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88308619686008781)
,p_theme_id=>42
,p_name=>'RTM_MEDIUM'
,p_display_name=>'Medium'
,p_display_sequence=>30
,p_css_classes=>'margin-top-md'
,p_group_id=>wwv_flow_api.id(88258166595008765)
,p_template_types=>'REGION'
,p_help_text=>'Adds a medium top margin to the region.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88309252187008782)
,p_theme_id=>42
,p_name=>'FTM_NONE'
,p_display_name=>'None'
,p_display_sequence=>10
,p_css_classes=>'margin-top-none'
,p_group_id=>wwv_flow_api.id(88239047060008760)
,p_template_types=>'FIELD'
,p_help_text=>'Removes the top margin for this field.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88309968462008782)
,p_theme_id=>42
,p_name=>'RTM_NONE'
,p_display_name=>'None'
,p_display_sequence=>10
,p_css_classes=>'margin-top-none'
,p_group_id=>wwv_flow_api.id(88258166595008765)
,p_template_types=>'REGION'
,p_help_text=>'Removes the top margin for this region.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88310658427008782)
,p_theme_id=>42
,p_name=>'FTM_SMALL'
,p_display_name=>'Small'
,p_display_sequence=>20
,p_css_classes=>'margin-top-sm'
,p_group_id=>wwv_flow_api.id(88239047060008760)
,p_template_types=>'FIELD'
,p_help_text=>'Adds a small top margin for this field.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88311411711008782)
,p_theme_id=>42
,p_name=>'RTM_SMALL'
,p_display_name=>'Small'
,p_display_sequence=>20
,p_css_classes=>'margin-top-sm'
,p_group_id=>wwv_flow_api.id(88258166595008765)
,p_template_types=>'REGION'
,p_help_text=>'Adds a small top margin to the region.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88312122716008782)
,p_theme_id=>42
,p_name=>'DANGER'
,p_display_name=>'Danger'
,p_display_sequence=>30
,p_css_classes=>'t-Button--danger'
,p_group_id=>wwv_flow_api.id(88235013350008759)
,p_template_types=>'BUTTON'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88312761107008783)
,p_theme_id=>42
,p_name=>'LARGEBOTTOMMARGIN'
,p_display_name=>'Large'
,p_display_sequence=>20
,p_css_classes=>'t-Button--gapBottom'
,p_group_id=>wwv_flow_api.id(88232988350008759)
,p_template_types=>'BUTTON'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88313531909008783)
,p_theme_id=>42
,p_name=>'LARGELEFTMARGIN'
,p_display_name=>'Large'
,p_display_sequence=>20
,p_css_classes=>'t-Button--gapLeft'
,p_group_id=>wwv_flow_api.id(88233360482008759)
,p_template_types=>'BUTTON'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88314157522008783)
,p_theme_id=>42
,p_name=>'LARGERIGHTMARGIN'
,p_display_name=>'Large'
,p_display_sequence=>20
,p_css_classes=>'t-Button--gapRight'
,p_group_id=>wwv_flow_api.id(88233771928008759)
,p_template_types=>'BUTTON'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88314936936008783)
,p_theme_id=>42
,p_name=>'LARGETOPMARGIN'
,p_display_name=>'Large'
,p_display_sequence=>20
,p_css_classes=>'t-Button--gapTop'
,p_group_id=>wwv_flow_api.id(88234231309008759)
,p_template_types=>'BUTTON'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88315553654008783)
,p_theme_id=>42
,p_name=>'LARGE'
,p_display_name=>'Large'
,p_display_sequence=>30
,p_css_classes=>'t-Button--large'
,p_group_id=>wwv_flow_api.id(88232588209008758)
,p_template_types=>'BUTTON'
,p_help_text=>'A large button.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88316341370008784)
,p_theme_id=>42
,p_name=>'DISPLAY_AS_LINK'
,p_display_name=>'Display as Link'
,p_display_sequence=>30
,p_css_classes=>'t-Button--link'
,p_group_id=>wwv_flow_api.id(88234565947008759)
,p_template_types=>'BUTTON'
,p_help_text=>'This option makes the button appear as a text link.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88316951868008784)
,p_theme_id=>42
,p_name=>'NOUI'
,p_display_name=>'Remove UI Decoration'
,p_display_sequence=>20
,p_css_classes=>'t-Button--noUI'
,p_group_id=>wwv_flow_api.id(88234565947008759)
,p_template_types=>'BUTTON'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88317672924008785)
,p_theme_id=>42
,p_name=>'SMALLBOTTOMMARGIN'
,p_display_name=>'Small'
,p_display_sequence=>10
,p_css_classes=>'t-Button--padBottom'
,p_group_id=>wwv_flow_api.id(88232988350008759)
,p_template_types=>'BUTTON'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88318380095008785)
,p_theme_id=>42
,p_name=>'SMALLLEFTMARGIN'
,p_display_name=>'Small'
,p_display_sequence=>10
,p_css_classes=>'t-Button--padLeft'
,p_group_id=>wwv_flow_api.id(88233360482008759)
,p_template_types=>'BUTTON'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88319052696008785)
,p_theme_id=>42
,p_name=>'SMALLRIGHTMARGIN'
,p_display_name=>'Small'
,p_display_sequence=>10
,p_css_classes=>'t-Button--padRight'
,p_group_id=>wwv_flow_api.id(88233771928008759)
,p_template_types=>'BUTTON'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88319751581008785)
,p_theme_id=>42
,p_name=>'SMALLTOPMARGIN'
,p_display_name=>'Small'
,p_display_sequence=>10
,p_css_classes=>'t-Button--padTop'
,p_group_id=>wwv_flow_api.id(88234231309008759)
,p_template_types=>'BUTTON'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88320504368008785)
,p_theme_id=>42
,p_name=>'PILL'
,p_display_name=>'Inner Button'
,p_display_sequence=>20
,p_css_classes=>'t-Button--pill'
,p_group_id=>wwv_flow_api.id(88231417216008758)
,p_template_types=>'BUTTON'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88321234773008786)
,p_theme_id=>42
,p_name=>'PILLEND'
,p_display_name=>'Last Button'
,p_display_sequence=>30
,p_css_classes=>'t-Button--pillEnd'
,p_group_id=>wwv_flow_api.id(88231417216008758)
,p_template_types=>'BUTTON'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88321908393008786)
,p_theme_id=>42
,p_name=>'PILLSTART'
,p_display_name=>'First Button'
,p_display_sequence=>10
,p_css_classes=>'t-Button--pillStart'
,p_group_id=>wwv_flow_api.id(88231417216008758)
,p_template_types=>'BUTTON'
,p_help_text=>'Use this for the start of a pill button.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88322568854008786)
,p_theme_id=>42
,p_name=>'PRIMARY'
,p_display_name=>'Primary'
,p_display_sequence=>10
,p_css_classes=>'t-Button--primary'
,p_group_id=>wwv_flow_api.id(88235013350008759)
,p_template_types=>'BUTTON'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88323332992008786)
,p_theme_id=>42
,p_name=>'SIMPLE'
,p_display_name=>'Simple'
,p_display_sequence=>10
,p_css_classes=>'t-Button--simple'
,p_group_id=>wwv_flow_api.id(88234565947008759)
,p_template_types=>'BUTTON'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88323975941008787)
,p_theme_id=>42
,p_name=>'SMALL'
,p_display_name=>'Small'
,p_display_sequence=>20
,p_css_classes=>'t-Button--small'
,p_group_id=>wwv_flow_api.id(88232588209008758)
,p_template_types=>'BUTTON'
,p_help_text=>'A small button.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88324659290008787)
,p_theme_id=>42
,p_name=>'STRETCH'
,p_display_name=>'Stretch'
,p_display_sequence=>10
,p_css_classes=>'t-Button--stretch'
,p_group_id=>wwv_flow_api.id(88235437492008759)
,p_template_types=>'BUTTON'
,p_help_text=>'Stretches button to fill container'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88325433474008787)
,p_theme_id=>42
,p_name=>'SUCCESS'
,p_display_name=>'Success'
,p_display_sequence=>40
,p_css_classes=>'t-Button--success'
,p_group_id=>wwv_flow_api.id(88235013350008759)
,p_template_types=>'BUTTON'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88326114478008787)
,p_theme_id=>42
,p_name=>'TINY'
,p_display_name=>'Tiny'
,p_display_sequence=>10
,p_css_classes=>'t-Button--tiny'
,p_group_id=>wwv_flow_api.id(88232588209008758)
,p_template_types=>'BUTTON'
,p_help_text=>'A very small button.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88326803195008787)
,p_theme_id=>42
,p_name=>'WARNING'
,p_display_name=>'Warning'
,p_display_sequence=>20
,p_css_classes=>'t-Button--warning'
,p_group_id=>wwv_flow_api.id(88235013350008759)
,p_template_types=>'BUTTON'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88327546452008788)
,p_theme_id=>42
,p_name=>'SHOWFORMLABELSABOVE'
,p_display_name=>'Show Form Labels Above'
,p_display_sequence=>10
,p_css_classes=>'t-Form--labelsAbove'
,p_group_id=>wwv_flow_api.id(88255398042008764)
,p_template_types=>'REGION'
,p_help_text=>'Show form labels above input fields.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88328158076008788)
,p_theme_id=>42
,p_name=>'FORMSIZELARGE'
,p_display_name=>'Large'
,p_display_sequence=>10
,p_css_classes=>'t-Form--large'
,p_group_id=>wwv_flow_api.id(88254245684008764)
,p_template_types=>'REGION'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88328876207008788)
,p_theme_id=>42
,p_name=>'FORMLEFTLABELS'
,p_display_name=>'Left'
,p_display_sequence=>20
,p_css_classes=>'t-Form--leftLabels'
,p_group_id=>wwv_flow_api.id(88254998844008764)
,p_template_types=>'REGION'
,p_help_text=>'Align form labels to left.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88329611175008788)
,p_theme_id=>42
,p_name=>'FORMREMOVEPADDING'
,p_display_name=>'Remove Padding'
,p_display_sequence=>20
,p_css_classes=>'t-Form--noPadding'
,p_group_id=>wwv_flow_api.id(88253801945008764)
,p_template_types=>'REGION'
,p_help_text=>'Removes padding between items.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88330341196008788)
,p_theme_id=>42
,p_name=>'FORMSLIMPADDING'
,p_display_name=>'Slim Padding'
,p_display_sequence=>10
,p_css_classes=>'t-Form--slimPadding'
,p_group_id=>wwv_flow_api.id(88253801945008764)
,p_template_types=>'REGION'
,p_help_text=>'Reduces form item padding to 4px.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88331034993008789)
,p_theme_id=>42
,p_name=>'STRETCH_FORM_FIELDS'
,p_display_name=>'Stretch Form Fields'
,p_display_sequence=>10
,p_css_classes=>'t-Form--stretchInputs'
,p_group_id=>wwv_flow_api.id(88254568466008764)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88331669906008789)
,p_theme_id=>42
,p_name=>'FORMSIZEXLARGE'
,p_display_name=>'X Large'
,p_display_sequence=>20
,p_css_classes=>'t-Form--xlarge'
,p_group_id=>wwv_flow_api.id(88254245684008764)
,p_template_types=>'REGION'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88332401306008789)
,p_theme_id=>42
,p_name=>'LARGE_FIELD'
,p_display_name=>'Large'
,p_display_sequence=>10
,p_css_classes=>'t-Form-fieldContainer--large'
,p_group_id=>wwv_flow_api.id(88238608825008760)
,p_template_types=>'FIELD'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88333073857008789)
,p_theme_id=>42
,p_name=>'POST_TEXT_BLOCK'
,p_display_name=>'Display as Block'
,p_display_sequence=>10
,p_css_classes=>'t-Form-fieldContainer--postTextBlock'
,p_group_id=>wwv_flow_api.id(88236165711008759)
,p_template_types=>'FIELD'
,p_help_text=>'Displays the Item Post Text in a block style immediately after the item.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88333841086008790)
,p_theme_id=>42
,p_name=>'PRE_TEXT_BLOCK'
,p_display_name=>'Display as Block'
,p_display_sequence=>10
,p_css_classes=>'t-Form-fieldContainer--preTextBlock'
,p_group_id=>wwv_flow_api.id(88236580449008759)
,p_template_types=>'FIELD'
,p_help_text=>'Displays the Item Pre Text in a block style immediately before the item.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88334470113008790)
,p_theme_id=>42
,p_name=>'DISPLAY_AS_PILL_BUTTON'
,p_display_name=>'Display as Pill Button'
,p_display_sequence=>10
,p_css_classes=>'t-Form-fieldContainer--radioButtonGroup'
,p_group_id=>wwv_flow_api.id(88237787473008760)
,p_template_types=>'FIELD'
,p_help_text=>'Displays the radio buttons to look like a button set / pill button.  Note that the the radio buttons must all be in the same row for this option to work.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88334898307008790)
,p_theme_id=>42
,p_name=>'STRETCH_FORM_ITEM'
,p_display_name=>'Stretch Form Item'
,p_display_sequence=>10
,p_css_classes=>'t-Form-fieldContainer--stretchInputs'
,p_template_types=>'FIELD'
,p_help_text=>'Stretches the form item to fill its container.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88335629151008790)
,p_theme_id=>42
,p_name=>'X_LARGE_SIZE'
,p_display_name=>'X Large'
,p_display_sequence=>20
,p_css_classes=>'t-Form-fieldContainer--xlarge'
,p_group_id=>wwv_flow_api.id(88238608825008760)
,p_template_types=>'FIELD'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88336267598008791)
,p_theme_id=>42
,p_name=>'HIDE_WHEN_ALL_ROWS_DISPLAYED'
,p_display_name=>'Hide when all rows displayed'
,p_display_sequence=>10
,p_css_classes=>'t-Report--hideNoPagination'
,p_group_id=>wwv_flow_api.id(88266983593008767)
,p_template_types=>'REPORT'
,p_help_text=>'This option will hide the pagination when all rows are displayed.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88547031223008883)
,p_theme_id=>42
,p_name=>'2_COLUMNS'
,p_display_name=>'2 Columns'
,p_display_sequence=>10
,p_list_template_id=>wwv_flow_api.id(88546529882008878)
,p_css_classes=>'t-MegaMenu--layout2Cols'
,p_group_id=>wwv_flow_api.id(88243812105008761)
,p_template_types=>'LIST'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88547363961008883)
,p_theme_id=>42
,p_name=>'3_COLUMNS'
,p_display_name=>'3 Columns'
,p_display_sequence=>20
,p_list_template_id=>wwv_flow_api.id(88546529882008878)
,p_css_classes=>'t-MegaMenu--layout3Cols'
,p_group_id=>wwv_flow_api.id(88243812105008761)
,p_template_types=>'LIST'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88547845021008883)
,p_theme_id=>42
,p_name=>'4_COLUMNS'
,p_display_name=>'4 Columns'
,p_display_sequence=>30
,p_list_template_id=>wwv_flow_api.id(88546529882008878)
,p_css_classes=>'t-MegaMenu--layout4Cols'
,p_group_id=>wwv_flow_api.id(88243812105008761)
,p_template_types=>'LIST'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88548160965008884)
,p_theme_id=>42
,p_name=>'5_COLUMNS'
,p_display_name=>'5 Columns'
,p_display_sequence=>40
,p_list_template_id=>wwv_flow_api.id(88546529882008878)
,p_css_classes=>'t-MegaMenu--layout5Cols'
,p_group_id=>wwv_flow_api.id(88243812105008761)
,p_template_types=>'LIST'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88548630470008884)
,p_theme_id=>42
,p_name=>'CUSTOM'
,p_display_name=>'Custom'
,p_display_sequence=>60
,p_list_template_id=>wwv_flow_api.id(88546529882008878)
,p_css_classes=>'t-MegaMenu--layoutCustom'
,p_group_id=>wwv_flow_api.id(88243812105008761)
,p_template_types=>'LIST'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88549005800008884)
,p_theme_id=>42
,p_name=>'DISPLAY_MENU_CALLOUT'
,p_display_name=>'Display Menu Callout'
,p_display_sequence=>20
,p_list_template_id=>wwv_flow_api.id(88546529882008878)
,p_css_classes=>'js-menu-callout'
,p_template_types=>'LIST'
,p_help_text=>'Displays a callout arrow that points to where the menu was activated from.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88549413713008884)
,p_theme_id=>42
,p_name=>'FULL_WIDTH'
,p_display_name=>'Full Width'
,p_display_sequence=>10
,p_list_template_id=>wwv_flow_api.id(88546529882008878)
,p_css_classes=>'t-MegaMenu--fullWidth'
,p_template_types=>'LIST'
,p_help_text=>'Stretches the menu to fill the width of the screen.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(88549765769008884)
,p_theme_id=>42
,p_name=>'STACKED'
,p_display_name=>'Stacked'
,p_display_sequence=>60
,p_list_template_id=>wwv_flow_api.id(88546529882008878)
,p_css_classes=>'t-MegaMenu--layoutStacked'
,p_group_id=>wwv_flow_api.id(88243812105008761)
,p_template_types=>'LIST'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495520470130880126)
,p_theme_id=>42
,p_name=>'HIDE_LABEL_ON_MOBILE'
,p_display_name=>'Hide Label on Mobile'
,p_display_sequence=>10
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_css_classes=>'t-Button--mobileHideLabel'
,p_template_types=>'BUTTON'
,p_help_text=>'This template options hides the button label on small screens.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495520688868880126)
,p_theme_id=>42
,p_name=>'RIGHTICON'
,p_display_name=>'Right'
,p_display_sequence=>20
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_css_classes=>'t-Button--iconRight'
,p_group_id=>wwv_flow_api.id(88232151678008758)
,p_template_types=>'BUTTON'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495520853724880126)
,p_theme_id=>42
,p_name=>'LEFTICON'
,p_display_name=>'Left'
,p_display_sequence=>10
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_css_classes=>'t-Button--iconLeft'
,p_group_id=>wwv_flow_api.id(88232151678008758)
,p_template_types=>'BUTTON'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495521242564880126)
,p_theme_id=>42
,p_name=>'SPIN'
,p_display_name=>'Spin'
,p_display_sequence=>10
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_css_classes=>'t-Button--hoverIconSpin'
,p_group_id=>wwv_flow_api.id(88231761740008758)
,p_template_types=>'BUTTON'
,p_help_text=>'The icon will spin on button hover or focus.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495521414255880126)
,p_theme_id=>42
,p_name=>'PUSH'
,p_display_name=>'Push'
,p_display_sequence=>20
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_css_classes=>'t-Button--hoverIconPush'
,p_group_id=>wwv_flow_api.id(88231761740008758)
,p_template_types=>'BUTTON'
,p_help_text=>'The icon will animate to the right or left on button hover or focus.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495521877519880126)
,p_theme_id=>42
,p_name=>'SPIN'
,p_display_name=>'Spin'
,p_display_sequence=>10
,p_button_template_id=>wwv_flow_api.id(12495522463331880131)
,p_css_classes=>'t-Button--hoverIconSpin'
,p_group_id=>wwv_flow_api.id(88231761740008758)
,p_template_types=>'BUTTON'
,p_help_text=>'The icon will spin on button hover or focus.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495522011421880127)
,p_theme_id=>42
,p_name=>'PUSH'
,p_display_name=>'Push'
,p_display_sequence=>20
,p_button_template_id=>wwv_flow_api.id(12495522463331880131)
,p_css_classes=>'t-Button--hoverIconPush'
,p_group_id=>wwv_flow_api.id(88231761740008758)
,p_template_types=>'BUTTON'
,p_help_text=>'The icon will animate to the right or left on button hover or focus.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495523249552880140)
,p_theme_id=>42
,p_name=>'SMALL'
,p_display_name=>'Small'
,p_display_sequence=>5
,p_list_template_id=>wwv_flow_api.id(12495524735818880142)
,p_css_classes=>'t-Tabs--small'
,p_group_id=>wwv_flow_api.id(88244617838008762)
,p_template_types=>'LIST'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495523430849880140)
,p_theme_id=>42
,p_name=>'SIMPLE'
,p_display_name=>'Simple'
,p_display_sequence=>10
,p_list_template_id=>wwv_flow_api.id(12495524735818880142)
,p_css_classes=>'t-Tabs--simple'
,p_group_id=>wwv_flow_api.id(88245023756008762)
,p_template_types=>'LIST'
,p_help_text=>'A very simplistic tab UI.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495523644208880140)
,p_theme_id=>42
,p_name=>'PILL'
,p_display_name=>'Pill'
,p_display_sequence=>20
,p_list_template_id=>wwv_flow_api.id(12495524735818880142)
,p_css_classes=>'t-Tabs--pill'
,p_group_id=>wwv_flow_api.id(88245023756008762)
,p_template_types=>'LIST'
,p_help_text=>'Displays tabs in a pill container.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495523859248880140)
,p_theme_id=>42
,p_name=>'LARGE'
,p_display_name=>'Large'
,p_display_sequence=>10
,p_list_template_id=>wwv_flow_api.id(12495524735818880142)
,p_css_classes=>'t-Tabs--large'
,p_group_id=>wwv_flow_api.id(88244617838008762)
,p_template_types=>'LIST'
,p_help_text=>'Increases font size and white space around tab items.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495524049575880140)
,p_theme_id=>42
,p_name=>'INLINE_WITH_LABEL'
,p_display_name=>'Inline with Label'
,p_display_sequence=>10
,p_list_template_id=>wwv_flow_api.id(12495524735818880142)
,p_css_classes=>'t-Tabs--inlineIcons'
,p_group_id=>wwv_flow_api.id(88242227251008761)
,p_template_types=>'LIST'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495524251143880140)
,p_theme_id=>42
,p_name=>'ABOVE_LABEL'
,p_display_name=>'Above Label'
,p_display_sequence=>20
,p_list_template_id=>wwv_flow_api.id(12495524735818880142)
,p_css_classes=>'t-Tabs--iconsAbove'
,p_group_id=>wwv_flow_api.id(88242227251008761)
,p_template_types=>'LIST'
,p_help_text=>'Places icons above tab label.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495524461988880140)
,p_theme_id=>42
,p_name=>'FILL_LABELS'
,p_display_name=>'Fill Labels'
,p_display_sequence=>1
,p_list_template_id=>wwv_flow_api.id(12495524735818880142)
,p_css_classes=>'t-Tabs--fillLabels'
,p_group_id=>wwv_flow_api.id(88243812105008761)
,p_template_types=>'LIST'
,p_help_text=>'Stretch tabs to fill to the width of the tabs container.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495524862618880143)
,p_theme_id=>42
,p_name=>'DISPLAY_MENU_CALLOUT'
,p_display_name=>'Display Menu Callout'
,p_display_sequence=>20
,p_list_template_id=>wwv_flow_api.id(12495525309455880143)
,p_css_classes=>'js-menu-callout'
,p_template_types=>'LIST'
,p_help_text=>'Use this option to add display a callout for the menu. Note that callout will only be displayed if the data-parent-element custom attribute is defined.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495525068278880143)
,p_theme_id=>42
,p_name=>'ADD_ACTIONS'
,p_display_name=>'Add Actions'
,p_display_sequence=>10
,p_list_template_id=>wwv_flow_api.id(12495525309455880143)
,p_css_classes=>'js-addActions'
,p_template_types=>'LIST'
,p_help_text=>'Enables you to define a keyboard shortcut to activate the menu item.'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495525495554880143)
,p_theme_id=>42
,p_name=>'VERTICAL_LIST'
,p_display_name=>'Vertical Orientation'
,p_display_sequence=>10
,p_list_template_id=>wwv_flow_api.id(12495526785023880145)
,p_css_classes=>'t-WizardSteps--vertical'
,p_template_types=>'LIST'
,p_help_text=>'Displays the wizard progress list in a vertical orientation and is suitable for displaying within a side column of a page.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495525642905880143)
,p_theme_id=>42
,p_name=>'HIDELABELS'
,p_display_name=>'Hide Labels'
,p_display_sequence=>30
,p_list_template_id=>wwv_flow_api.id(12495526785023880145)
,p_css_classes=>'t-WizardSteps--hideLabels'
,p_group_id=>wwv_flow_api.id(88243392705008761)
,p_template_types=>'LIST'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495525829841880143)
,p_theme_id=>42
,p_name=>'ALLSTEPS'
,p_display_name=>'All Steps'
,p_display_sequence=>10
,p_list_template_id=>wwv_flow_api.id(12495526785023880145)
,p_css_classes=>'t-WizardSteps--displayLabels'
,p_group_id=>wwv_flow_api.id(88243392705008761)
,p_template_types=>'LIST'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495526055652880143)
,p_theme_id=>42
,p_name=>'CURRENTSTEPONLY'
,p_display_name=>'Current Step Only'
,p_display_sequence=>20
,p_list_template_id=>wwv_flow_api.id(12495526785023880145)
,p_css_classes=>'t-WizardSteps--displayCurrentLabelOnly'
,p_group_id=>wwv_flow_api.id(88243392705008761)
,p_template_types=>'LIST'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495526423626880143)
,p_theme_id=>42
,p_name=>'WIZARD_PROGRESS_LINKS'
,p_display_name=>'Make Wizard Steps Clickable'
,p_display_sequence=>40
,p_list_template_id=>wwv_flow_api.id(12495526785023880145)
,p_css_classes=>'js-wizardProgressLinks'
,p_template_types=>'LIST'
,p_help_text=>'This option will make the wizard steps clickable links.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495526839144880145)
,p_theme_id=>42
,p_name=>'LABEL_ABOVE_LG'
,p_display_name=>'Display labels above'
,p_display_sequence=>20
,p_list_template_id=>wwv_flow_api.id(12495528385085880146)
,p_css_classes=>'t-NavTabs--stacked'
,p_group_id=>wwv_flow_api.id(88241439994008761)
,p_template_types=>'LIST'
,p_help_text=>'Display the label stacked above the icon and badge'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495527024406880145)
,p_theme_id=>42
,p_name=>'LABEL_INLINE_LG'
,p_display_name=>'Display labels inline'
,p_display_sequence=>10
,p_list_template_id=>wwv_flow_api.id(12495528385085880146)
,p_css_classes=>'t-NavTabs--inlineLabels-lg'
,p_group_id=>wwv_flow_api.id(88241439994008761)
,p_template_types=>'LIST'
,p_help_text=>'Display the label inline with the icon and badge'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495527255570880145)
,p_theme_id=>42
,p_name=>'HIDE_LABELS_SM'
,p_display_name=>'Do not display labels'
,p_display_sequence=>50
,p_list_template_id=>wwv_flow_api.id(12495528385085880146)
,p_css_classes=>'t-NavTabs--hiddenLabels-sm'
,p_group_id=>wwv_flow_api.id(88244180363008761)
,p_template_types=>'LIST'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495527402028880145)
,p_theme_id=>42
,p_name=>'NO_LABEL_LG'
,p_display_name=>'Do not display labels'
,p_display_sequence=>30
,p_list_template_id=>wwv_flow_api.id(12495528385085880146)
,p_css_classes=>'t-NavTabs--hiddenLabels-lg'
,p_group_id=>wwv_flow_api.id(88241439994008761)
,p_template_types=>'LIST'
,p_help_text=>'Hides the label for the list item'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495527863440880145)
,p_theme_id=>42
,p_name=>'DISPLAY_LABELS_SM'
,p_display_name=>'Display labels'
,p_display_sequence=>40
,p_list_template_id=>wwv_flow_api.id(12495528385085880146)
,p_css_classes=>'t-NavTabs--displayLabels-sm'
,p_group_id=>wwv_flow_api.id(88244180363008761)
,p_template_types=>'LIST'
,p_help_text=>'Displays the label for the list items below the icon'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495528443868880146)
,p_theme_id=>42
,p_name=>'BEHAVE_LIKE_TABS'
,p_display_name=>'Behave Like Tabs'
,p_display_sequence=>10
,p_list_template_id=>wwv_flow_api.id(12495529517389880148)
,p_css_classes=>'js-tabLike'
,p_template_types=>'LIST'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495528844306880146)
,p_theme_id=>42
,p_name=>'SHOW_SUB_MENU_ICONS'
,p_display_name=>'Show Sub Menu Icons'
,p_display_sequence=>30
,p_list_template_id=>wwv_flow_api.id(12495529517389880148)
,p_css_classes=>'js-showSubMenuIcons'
,p_template_types=>'LIST'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495529023501880146)
,p_theme_id=>42
,p_name=>'DISPLAY_MENU_CALLOUT'
,p_display_name=>'Display Menu Callout'
,p_display_sequence=>50
,p_list_template_id=>wwv_flow_api.id(12495529517389880148)
,p_css_classes=>'js-menu-callout'
,p_template_types=>'LIST'
,p_help_text=>'Use this option to add display a callout for the menu.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495529254324880146)
,p_theme_id=>42
,p_name=>'ADD_ACTIONS'
,p_display_name=>'Add Actions'
,p_display_sequence=>40
,p_list_template_id=>wwv_flow_api.id(12495529517389880148)
,p_css_classes=>'js-addActions'
,p_template_types=>'LIST'
,p_help_text=>'Use this option to add shortcuts for menu items. Note that actions.js must be included on your page to support this functionality.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495529607350880148)
,p_theme_id=>42
,p_name=>'SHOWTOPICONS'
,p_display_name=>'For Top Level Items Only'
,p_display_sequence=>10
,p_list_template_id=>wwv_flow_api.id(12495531199768880148)
,p_css_classes=>'t-LinksList--showTopIcons'
,p_group_id=>wwv_flow_api.id(88241803542008761)
,p_template_types=>'LIST'
,p_help_text=>'This will show icons for top level items of the list only. It will not show icons for sub lists.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495529811979880148)
,p_theme_id=>42
,p_name=>'SHOWICONS'
,p_display_name=>'For All Items'
,p_display_sequence=>20
,p_list_template_id=>wwv_flow_api.id(12495531199768880148)
,p_css_classes=>'t-LinksList--showIcons'
,p_group_id=>wwv_flow_api.id(88241803542008761)
,p_template_types=>'LIST'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495530224839880148)
,p_theme_id=>42
,p_name=>'SHOWBADGES'
,p_display_name=>'Show Badges'
,p_display_sequence=>10
,p_list_template_id=>wwv_flow_api.id(12495531199768880148)
,p_css_classes=>'t-LinksList--showBadge'
,p_template_types=>'LIST'
,p_help_text=>'Show badge to right of link (requires Attribute 1 to be populated)'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495530420299880148)
,p_theme_id=>42
,p_name=>'SHOWGOTOARROW'
,p_display_name=>'Show Right Arrow'
,p_display_sequence=>20
,p_list_template_id=>wwv_flow_api.id(12495531199768880148)
,p_css_classes=>'t-LinksList--showArrow'
,p_template_types=>'LIST'
,p_help_text=>'Show arrow to the right of link'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495530611793880148)
,p_theme_id=>42
,p_name=>'DISABLETEXTWRAPPING'
,p_display_name=>'Disable Text Wrapping'
,p_display_sequence=>30
,p_list_template_id=>wwv_flow_api.id(12495531199768880148)
,p_css_classes=>'t-LinksList--nowrap'
,p_template_types=>'LIST'
,p_help_text=>'Do not allow link text to wrap to new lines. Truncate with ellipsis.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495530876602880148)
,p_theme_id=>42
,p_name=>'ACTIONS'
,p_display_name=>'Actions'
,p_display_sequence=>10
,p_list_template_id=>wwv_flow_api.id(12495531199768880148)
,p_css_classes=>'t-LinksList--actions'
,p_group_id=>wwv_flow_api.id(88245023756008762)
,p_template_types=>'LIST'
,p_help_text=>'Render as actions to be placed on the right side column.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495531210901880149)
,p_theme_id=>42
,p_name=>'BEHAVE_LIKE_TABS'
,p_display_name=>'Behave Like Tabs'
,p_display_sequence=>1
,p_list_template_id=>wwv_flow_api.id(12495532306266880151)
,p_css_classes=>'js-tabLike'
,p_template_types=>'LIST'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495531659842880149)
,p_theme_id=>42
,p_name=>'SHOW_SUB_MENU_ICONS'
,p_display_name=>'Show Sub Menu Icons'
,p_display_sequence=>1
,p_list_template_id=>wwv_flow_api.id(12495532306266880151)
,p_css_classes=>'js-showSubMenuIcons'
,p_template_types=>'LIST'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495531809266880149)
,p_theme_id=>42
,p_name=>'DISPLAY_MENU_CALLOUT'
,p_display_name=>'Display Menu Callout'
,p_display_sequence=>50
,p_list_template_id=>wwv_flow_api.id(12495532306266880151)
,p_css_classes=>'js-menu-callout'
,p_template_types=>'LIST'
,p_help_text=>'Use this option to add display a callout for the menu.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495532058926880149)
,p_theme_id=>42
,p_name=>'ADD_ACTIONS'
,p_display_name=>'Add Actions'
,p_display_sequence=>1
,p_list_template_id=>wwv_flow_api.id(12495532306266880151)
,p_css_classes=>'js-addActions'
,p_template_types=>'LIST'
,p_help_text=>'Use this option to add shortcuts for menu items. Note that actions.js must be included on your page to support this functionality.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495532499920880151)
,p_theme_id=>42
,p_name=>'STYLE_B'
,p_display_name=>'Style B'
,p_display_sequence=>30
,p_list_template_id=>wwv_flow_api.id(12495533999726880152)
,p_css_classes=>'t-TreeNav--styleB'
,p_group_id=>wwv_flow_api.id(88245023756008762)
,p_template_types=>'LIST'
,p_help_text=>'Style Variation B'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495532636217880151)
,p_theme_id=>42
,p_name=>'STYLE_A'
,p_display_name=>'Style A'
,p_display_sequence=>20
,p_list_template_id=>wwv_flow_api.id(12495533999726880152)
,p_css_classes=>'t-TreeNav--styleA'
,p_group_id=>wwv_flow_api.id(88245023756008762)
,p_template_types=>'LIST'
,p_help_text=>'Style Variation A'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495532875262880152)
,p_theme_id=>42
,p_name=>'STYLE_C'
,p_display_name=>'Classic'
,p_display_sequence=>10
,p_list_template_id=>wwv_flow_api.id(12495533999726880152)
,p_css_classes=>'t-TreeNav--classic'
,p_group_id=>wwv_flow_api.id(88245023756008762)
,p_template_types=>'LIST'
,p_help_text=>'Classic Style'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495533001635880152)
,p_theme_id=>42
,p_name=>'COLLAPSE_STYLE_HIDDEN'
,p_display_name=>'Hidden'
,p_display_sequence=>20
,p_list_template_id=>wwv_flow_api.id(12495533999726880152)
,p_css_classes=>'js-navCollapsed--hidden'
,p_group_id=>wwv_flow_api.id(88240635250008760)
,p_template_types=>'LIST'
,p_help_text=>'Completely hide the navigation menu when it is collapsed.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495533260166880152)
,p_theme_id=>42
,p_name=>'ICON_DEFAULT'
,p_display_name=>'Icon (Default)'
,p_display_sequence=>10
,p_list_template_id=>wwv_flow_api.id(12495533999726880152)
,p_css_classes=>'js-navCollapsed--default'
,p_group_id=>wwv_flow_api.id(88240635250008760)
,p_template_types=>'LIST'
,p_help_text=>'Display icons when the navigation menu is collapsed for large screens.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495533672614880152)
,p_theme_id=>42
,p_name=>'COLLAPSED_DEFAULT'
,p_display_name=>'Collapsed by Default'
,p_display_sequence=>10
,p_list_template_id=>wwv_flow_api.id(12495533999726880152)
,p_css_classes=>'js-defaultCollapsed'
,p_template_types=>'LIST'
,p_help_text=>'This option will load the side navigation menu in a collapsed state by default.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495534019905880152)
,p_theme_id=>42
,p_name=>'DISPLAY_MENU_CALLOUT'
,p_display_name=>'Display Menu Callout'
,p_display_sequence=>10
,p_list_template_id=>wwv_flow_api.id(12495534382344880154)
,p_css_classes=>'js-menu-callout'
,p_template_types=>'LIST'
,p_help_text=>'Use this option to add display a callout for the menu.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495534440938880156)
,p_theme_id=>42
,p_name=>'APPLY_THEME_COLORS'
,p_display_name=>'Apply Theme Colors'
,p_display_sequence=>40
,p_list_template_id=>wwv_flow_api.id(12495537187789880157)
,p_css_classes=>'u-colors'
,p_template_types=>'LIST'
,p_help_text=>'Applies colors from the Theme''s color palette to icons in the list.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495534609191880156)
,p_theme_id=>42
,p_name=>'SHOW_ICONS'
,p_display_name=>'Show Icons'
,p_display_sequence=>10
,p_list_template_id=>wwv_flow_api.id(12495537187789880157)
,p_css_classes=>'t-MediaList--showIcons'
,p_template_types=>'LIST'
,p_help_text=>'Display an icon next to the list item.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495534848193880156)
,p_theme_id=>42
,p_name=>'SHOW_DESCRIPTION'
,p_display_name=>'Show Description'
,p_display_sequence=>20
,p_list_template_id=>wwv_flow_api.id(12495537187789880157)
,p_css_classes=>'t-MediaList--showDesc'
,p_template_types=>'LIST'
,p_help_text=>'Shows the description (Attribute 1) for each list item.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495535049264880156)
,p_theme_id=>42
,p_name=>'SHOW_BADGES'
,p_display_name=>'Show Badges'
,p_display_sequence=>30
,p_list_template_id=>wwv_flow_api.id(12495537187789880157)
,p_css_classes=>'t-MediaList--showBadges'
,p_template_types=>'LIST'
,p_help_text=>'Show a badge (Attribute 2) to the right of the list item.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495535208776880156)
,p_theme_id=>42
,p_name=>'LIST_SIZE_LARGE'
,p_display_name=>'Large'
,p_display_sequence=>10
,p_list_template_id=>wwv_flow_api.id(12495537187789880157)
,p_css_classes=>'t-MediaList--large force-fa-lg'
,p_group_id=>wwv_flow_api.id(88244617838008762)
,p_template_types=>'LIST'
,p_help_text=>'Increases the size of the text and icons in the list.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495535691639880156)
,p_theme_id=>42
,p_name=>'ICONS_SQUARE'
,p_display_name=>'Square'
,p_display_sequence=>20
,p_list_template_id=>wwv_flow_api.id(12495537187789880157)
,p_css_classes=>'t-MediaList--iconsSquare'
,p_group_id=>wwv_flow_api.id(88242582467008761)
,p_template_types=>'LIST'
,p_help_text=>'The icons are displayed within a square shape.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495535851622880156)
,p_theme_id=>42
,p_name=>'ICONS_ROUNDED'
,p_display_name=>'Rounded Corners'
,p_display_sequence=>10
,p_list_template_id=>wwv_flow_api.id(12495537187789880157)
,p_css_classes=>'t-MediaList--iconsRounded'
,p_group_id=>wwv_flow_api.id(88242582467008761)
,p_template_types=>'LIST'
,p_help_text=>'The icons are displayed within a square with rounded corners.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495536075167880156)
,p_theme_id=>42
,p_name=>'SPANHORIZONTAL'
,p_display_name=>'Span Horizontal'
,p_display_sequence=>50
,p_list_template_id=>wwv_flow_api.id(12495537187789880157)
,p_css_classes=>'t-MediaList--horizontal'
,p_group_id=>wwv_flow_api.id(88243812105008761)
,p_template_types=>'LIST'
,p_help_text=>'Show all list items in one horizontal row.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495536205681880156)
,p_theme_id=>42
,p_name=>'5COLUMNGRID'
,p_display_name=>'5 Column Grid'
,p_display_sequence=>40
,p_list_template_id=>wwv_flow_api.id(12495537187789880157)
,p_css_classes=>'t-MediaList--cols t-MediaList--5cols'
,p_group_id=>wwv_flow_api.id(88243812105008761)
,p_template_types=>'LIST'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495536469962880156)
,p_theme_id=>42
,p_name=>'4COLUMNGRID'
,p_display_name=>'4 Column Grid'
,p_display_sequence=>30
,p_list_template_id=>wwv_flow_api.id(12495537187789880157)
,p_css_classes=>'t-MediaList--cols t-MediaList--4cols'
,p_group_id=>wwv_flow_api.id(88243812105008761)
,p_template_types=>'LIST'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495536648855880156)
,p_theme_id=>42
,p_name=>'3COLUMNGRID'
,p_display_name=>'3 Column Grid'
,p_display_sequence=>20
,p_list_template_id=>wwv_flow_api.id(12495537187789880157)
,p_css_classes=>'t-MediaList--cols t-MediaList--3cols'
,p_group_id=>wwv_flow_api.id(88243812105008761)
,p_template_types=>'LIST'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495536879435880157)
,p_theme_id=>42
,p_name=>'2COLUMNGRID'
,p_display_name=>'2 Column Grid'
,p_display_sequence=>10
,p_list_template_id=>wwv_flow_api.id(12495537187789880157)
,p_css_classes=>'t-MediaList--cols t-MediaList--2cols'
,p_group_id=>wwv_flow_api.id(88243812105008761)
,p_template_types=>'LIST'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495537298467880157)
,p_theme_id=>42
,p_name=>'USE_THEME_COLORS'
,p_display_name=>'Apply Theme Colors'
,p_display_sequence=>10
,p_list_template_id=>wwv_flow_api.id(12495542773533880165)
,p_css_classes=>'u-colors'
,p_template_types=>'LIST'
,p_help_text=>'Applies the colors from the theme''s color palette to the icons or initials within cards.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495537412177880157)
,p_theme_id=>42
,p_name=>'CARDS_STACKED'
,p_display_name=>'Stacked'
,p_display_sequence=>5
,p_list_template_id=>wwv_flow_api.id(12495542773533880165)
,p_css_classes=>'t-Cards--stacked'
,p_group_id=>wwv_flow_api.id(88243812105008761)
,p_template_types=>'LIST'
,p_help_text=>'Stacks the cards on top of each other.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495537692510880157)
,p_theme_id=>42
,p_name=>'SPAN_HORIZONTALLY'
,p_display_name=>'Span Horizontally'
,p_display_sequence=>70
,p_list_template_id=>wwv_flow_api.id(12495542773533880165)
,p_css_classes=>'t-Cards--spanHorizontally'
,p_group_id=>wwv_flow_api.id(88243812105008761)
,p_template_types=>'LIST'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495537887100880157)
,p_theme_id=>42
,p_name=>'ICONS_SQUARE'
,p_display_name=>'Square'
,p_display_sequence=>20
,p_list_template_id=>wwv_flow_api.id(12495542773533880165)
,p_css_classes=>'t-Cards--iconsSquare'
,p_group_id=>wwv_flow_api.id(88242582467008761)
,p_template_types=>'LIST'
,p_help_text=>'The icons are displayed within a square shape.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495538057178880157)
,p_theme_id=>42
,p_name=>'ICONS_ROUNDED'
,p_display_name=>'Rounded Corners'
,p_display_sequence=>10
,p_list_template_id=>wwv_flow_api.id(12495542773533880165)
,p_css_classes=>'t-Cards--iconsRounded'
,p_group_id=>wwv_flow_api.id(88242582467008761)
,p_template_types=>'LIST'
,p_help_text=>'The icons are displayed within a square with rounded corners.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495538480427880159)
,p_theme_id=>42
,p_name=>'HIDDEN_BODY_TEXT'
,p_display_name=>'Hidden'
,p_display_sequence=>50
,p_list_template_id=>wwv_flow_api.id(12495542773533880165)
,p_css_classes=>'t-Cards--hideBody'
,p_group_id=>wwv_flow_api.id(88240213146008760)
,p_template_types=>'LIST'
,p_help_text=>'This option hides the card body which contains description and subtext.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495538681630880159)
,p_theme_id=>42
,p_name=>'FLOAT'
,p_display_name=>'Float'
,p_display_sequence=>60
,p_list_template_id=>wwv_flow_api.id(12495542773533880165)
,p_css_classes=>'t-Cards--float'
,p_group_id=>wwv_flow_api.id(88243812105008761)
,p_template_types=>'LIST'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495538839944880159)
,p_theme_id=>42
,p_name=>'BLOCK'
,p_display_name=>'Block'
,p_display_sequence=>40
,p_list_template_id=>wwv_flow_api.id(12495542773533880165)
,p_css_classes=>'t-Cards--featured t-Cards--block force-fa-lg'
,p_group_id=>wwv_flow_api.id(88245023756008762)
,p_template_types=>'LIST'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495539092326880159)
,p_theme_id=>42
,p_name=>'FEATURED'
,p_display_name=>'Featured'
,p_display_sequence=>30
,p_list_template_id=>wwv_flow_api.id(12495542773533880165)
,p_css_classes=>'t-Cards--featured force-fa-lg'
,p_group_id=>wwv_flow_api.id(88245023756008762)
,p_template_types=>'LIST'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495539246488880159)
,p_theme_id=>42
,p_name=>'DISPLAY_SUBTITLE'
,p_display_name=>'Display Subtitle'
,p_display_sequence=>20
,p_list_template_id=>wwv_flow_api.id(12495542773533880165)
,p_css_classes=>'t-Cards--displaySubtitle'
,p_template_types=>'LIST'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495539485418880159)
,p_theme_id=>42
,p_name=>'DISPLAY_INITIALS'
,p_display_name=>'Display Initials'
,p_display_sequence=>20
,p_list_template_id=>wwv_flow_api.id(12495542773533880165)
,p_css_classes=>'t-Cards--displayInitials'
,p_group_id=>wwv_flow_api.id(88242227251008761)
,p_template_types=>'LIST'
,p_help_text=>'Initials come from List Attribute 3'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495539660270880159)
,p_theme_id=>42
,p_name=>'DISPLAY_ICONS'
,p_display_name=>'Display Icons'
,p_display_sequence=>10
,p_list_template_id=>wwv_flow_api.id(12495542773533880165)
,p_css_classes=>'t-Cards--displayIcons'
,p_group_id=>wwv_flow_api.id(88242227251008761)
,p_template_types=>'LIST'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495540092530880159)
,p_theme_id=>42
,p_name=>'4_LINES'
,p_display_name=>'4 Lines'
,p_display_sequence=>30
,p_list_template_id=>wwv_flow_api.id(12495542773533880165)
,p_css_classes=>'t-Cards--desc-4ln'
,p_group_id=>wwv_flow_api.id(88240213146008760)
,p_template_types=>'LIST'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495540295899880160)
,p_theme_id=>42
,p_name=>'3_LINES'
,p_display_name=>'3 Lines'
,p_display_sequence=>20
,p_list_template_id=>wwv_flow_api.id(12495542773533880165)
,p_css_classes=>'t-Cards--desc-3ln'
,p_group_id=>wwv_flow_api.id(88240213146008760)
,p_template_types=>'LIST'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495540474923880160)
,p_theme_id=>42
,p_name=>'2_LINES'
,p_display_name=>'2 Lines'
,p_display_sequence=>10
,p_list_template_id=>wwv_flow_api.id(12495542773533880165)
,p_css_classes=>'t-Cards--desc-2ln'
,p_group_id=>wwv_flow_api.id(88240213146008760)
,p_template_types=>'LIST'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495540805281880160)
,p_theme_id=>42
,p_name=>'COMPACT'
,p_display_name=>'Compact'
,p_display_sequence=>20
,p_list_template_id=>wwv_flow_api.id(12495542773533880165)
,p_css_classes=>'t-Cards--compact'
,p_group_id=>wwv_flow_api.id(88245023756008762)
,p_template_types=>'LIST'
,p_help_text=>'Use this option when you want to show smaller cards.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495541087730880160)
,p_theme_id=>42
,p_name=>'2_COLUMNS'
,p_display_name=>'2 Columns'
,p_display_sequence=>10
,p_list_template_id=>wwv_flow_api.id(12495542773533880165)
,p_css_classes=>'t-Cards--cols'
,p_group_id=>wwv_flow_api.id(88243812105008761)
,p_template_types=>'LIST'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495541264314880162)
,p_theme_id=>42
,p_name=>'BASIC'
,p_display_name=>'Basic'
,p_display_sequence=>10
,p_list_template_id=>wwv_flow_api.id(12495542773533880165)
,p_css_classes=>'t-Cards--basic'
,p_group_id=>wwv_flow_api.id(88245023756008762)
,p_template_types=>'LIST'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495541455298880162)
,p_theme_id=>42
,p_name=>'RAISE_CARD'
,p_display_name=>'Raise Card'
,p_display_sequence=>20
,p_list_template_id=>wwv_flow_api.id(12495542773533880165)
,p_css_classes=>'t-Cards--animRaiseCard'
,p_group_id=>wwv_flow_api.id(88239400438008760)
,p_template_types=>'LIST'
,p_help_text=>'Raises the card so it pops up.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495541633607880162)
,p_theme_id=>42
,p_name=>'COLOR_FILL'
,p_display_name=>'Color Fill'
,p_display_sequence=>10
,p_list_template_id=>wwv_flow_api.id(12495542773533880165)
,p_css_classes=>'t-Cards--animColorFill'
,p_group_id=>wwv_flow_api.id(88239400438008760)
,p_template_types=>'LIST'
,p_help_text=>'Fills the card background with the color of the icon or default link style.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495542092200880165)
,p_theme_id=>42
,p_name=>'5_COLUMNS'
,p_display_name=>'5 Columns'
,p_display_sequence=>50
,p_list_template_id=>wwv_flow_api.id(12495542773533880165)
,p_css_classes=>'t-Cards--5cols'
,p_group_id=>wwv_flow_api.id(88243812105008761)
,p_template_types=>'LIST'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495542291041880165)
,p_theme_id=>42
,p_name=>'4_COLUMNS'
,p_display_name=>'4 Columns'
,p_display_sequence=>30
,p_list_template_id=>wwv_flow_api.id(12495542773533880165)
,p_css_classes=>'t-Cards--4cols'
,p_group_id=>wwv_flow_api.id(88243812105008761)
,p_template_types=>'LIST'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495542424759880165)
,p_theme_id=>42
,p_name=>'3_COLUMNS'
,p_display_name=>'3 Columns'
,p_display_sequence=>20
,p_list_template_id=>wwv_flow_api.id(12495542773533880165)
,p_css_classes=>'t-Cards--3cols'
,p_group_id=>wwv_flow_api.id(88243812105008761)
,p_template_types=>'LIST'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495542869236880165)
,p_theme_id=>42
,p_name=>'APPLY_THEME_COLORS'
,p_display_name=>'Apply Theme Colors'
,p_display_sequence=>10
,p_list_template_id=>wwv_flow_api.id(12495546789751880176)
,p_css_classes=>'u-colors'
,p_template_types=>'LIST'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495543063075880165)
,p_theme_id=>42
,p_name=>'XXLARGE'
,p_display_name=>'128px'
,p_display_sequence=>50
,p_list_template_id=>wwv_flow_api.id(12495546789751880176)
,p_css_classes=>'t-BadgeList--xxlarge'
,p_group_id=>wwv_flow_api.id(88239765295008760)
,p_template_types=>'LIST'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495543217773880167)
,p_theme_id=>42
,p_name=>'XLARGE'
,p_display_name=>'96px'
,p_display_sequence=>40
,p_list_template_id=>wwv_flow_api.id(12495546789751880176)
,p_css_classes=>'t-BadgeList--xlarge'
,p_group_id=>wwv_flow_api.id(88239765295008760)
,p_template_types=>'LIST'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495543432138880167)
,p_theme_id=>42
,p_name=>'STACKED'
,p_display_name=>'Stacked'
,p_display_sequence=>10
,p_list_template_id=>wwv_flow_api.id(12495546789751880176)
,p_css_classes=>'t-BadgeList--stacked'
,p_group_id=>wwv_flow_api.id(88243812105008761)
,p_template_types=>'LIST'
,p_help_text=>'Stack badges on top of each other'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495543642357880167)
,p_theme_id=>42
,p_name=>'SMALL'
,p_display_name=>'32px'
,p_display_sequence=>10
,p_list_template_id=>wwv_flow_api.id(12495546789751880176)
,p_css_classes=>'t-BadgeList--small'
,p_group_id=>wwv_flow_api.id(88239765295008760)
,p_template_types=>'LIST'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495543815075880167)
,p_theme_id=>42
,p_name=>'MEDIUM'
,p_display_name=>'48px'
,p_display_sequence=>20
,p_list_template_id=>wwv_flow_api.id(12495546789751880176)
,p_css_classes=>'t-BadgeList--medium'
,p_group_id=>wwv_flow_api.id(88239765295008760)
,p_template_types=>'LIST'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495544084965880167)
,p_theme_id=>42
,p_name=>'LARGE'
,p_display_name=>'64px'
,p_display_sequence=>30
,p_list_template_id=>wwv_flow_api.id(12495546789751880176)
,p_css_classes=>'t-BadgeList--large'
,p_group_id=>wwv_flow_api.id(88239765295008760)
,p_template_types=>'LIST'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495544415469880167)
,p_theme_id=>42
,p_name=>'FLOATITEMS'
,p_display_name=>'Float Items'
,p_display_sequence=>70
,p_list_template_id=>wwv_flow_api.id(12495546789751880176)
,p_css_classes=>'t-BadgeList--float'
,p_group_id=>wwv_flow_api.id(88243812105008761)
,p_template_types=>'LIST'
,p_help_text=>'Float badges to left'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495544679195880167)
,p_theme_id=>42
,p_name=>'FLEXIBLEBOX'
,p_display_name=>'Flexible Box'
,p_display_sequence=>80
,p_list_template_id=>wwv_flow_api.id(12495546789751880176)
,p_css_classes=>'t-BadgeList--flex'
,p_group_id=>wwv_flow_api.id(88243812105008761)
,p_template_types=>'LIST'
,p_help_text=>'Use flexbox to arrange items'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495544842685880167)
,p_theme_id=>42
,p_name=>'FIXED'
,p_display_name=>'Span Horizontally'
,p_display_sequence=>60
,p_list_template_id=>wwv_flow_api.id(12495546789751880176)
,p_css_classes=>'t-BadgeList--fixed'
,p_group_id=>wwv_flow_api.id(88243812105008761)
,p_template_types=>'LIST'
,p_help_text=>'Span badges horizontally'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495545083611880168)
,p_theme_id=>42
,p_name=>'GRID'
,p_display_name=>'Grid'
,p_display_sequence=>30
,p_list_template_id=>wwv_flow_api.id(12495546789751880176)
,p_css_classes=>'t-BadgeList--dash'
,p_group_id=>wwv_flow_api.id(88245023756008762)
,p_template_types=>'LIST'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495545224789880168)
,p_theme_id=>42
,p_name=>'5COLUMNGRID'
,p_display_name=>'5 Column Grid'
,p_display_sequence=>50
,p_list_template_id=>wwv_flow_api.id(12495546789751880176)
,p_css_classes=>'t-BadgeList--cols t-BadgeList--5cols'
,p_group_id=>wwv_flow_api.id(88243812105008761)
,p_template_types=>'LIST'
,p_help_text=>'Arrange badges in a 5 column grid'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495545457700880168)
,p_theme_id=>42
,p_name=>'4COLUMNGRID'
,p_display_name=>'4 Column Grid'
,p_display_sequence=>40
,p_list_template_id=>wwv_flow_api.id(12495546789751880176)
,p_css_classes=>'t-BadgeList--cols t-BadgeList--4cols'
,p_group_id=>wwv_flow_api.id(88243812105008761)
,p_template_types=>'LIST'
,p_help_text=>'Arrange badges in 4 column grid'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495545659348880168)
,p_theme_id=>42
,p_name=>'3COLUMNGRID'
,p_display_name=>'3 Column Grid'
,p_display_sequence=>30
,p_list_template_id=>wwv_flow_api.id(12495546789751880176)
,p_css_classes=>'t-BadgeList--cols t-BadgeList--3cols'
,p_group_id=>wwv_flow_api.id(88243812105008761)
,p_template_types=>'LIST'
,p_help_text=>'Arrange badges in a 3 column grid'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495545855921880168)
,p_theme_id=>42
,p_name=>'2COLUMNGRID'
,p_display_name=>'2 Column Grid'
,p_display_sequence=>20
,p_list_template_id=>wwv_flow_api.id(12495546789751880176)
,p_css_classes=>'t-BadgeList--cols'
,p_group_id=>wwv_flow_api.id(88243812105008761)
,p_template_types=>'LIST'
,p_help_text=>'Arrange badges in a two column grid'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495546228455880170)
,p_theme_id=>42
,p_name=>'CIRCULAR'
,p_display_name=>'Circular'
,p_display_sequence=>20
,p_list_template_id=>wwv_flow_api.id(12495546789751880176)
,p_css_classes=>'t-BadgeList--circular'
,p_group_id=>wwv_flow_api.id(88245023756008762)
,p_template_types=>'LIST'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495546805795880177)
,p_theme_id=>42
,p_name=>'VARIABLE_SMALL'
,p_display_name=>'Variable - Small'
,p_display_sequence=>40
,p_report_template_id=>wwv_flow_api.id(12495548550946880181)
,p_css_classes=>'t-AVPList--variableLabelSmall'
,p_group_id=>wwv_flow_api.id(88266187296008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495547078982880177)
,p_theme_id=>42
,p_name=>'VARIABLE_MEDIUM'
,p_display_name=>'Variable - Medium'
,p_display_sequence=>50
,p_report_template_id=>wwv_flow_api.id(12495548550946880181)
,p_css_classes=>'t-AVPList--variableLabelMedium'
,p_group_id=>wwv_flow_api.id(88266187296008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495547291189880177)
,p_theme_id=>42
,p_name=>'VARIABLE_LARGE'
,p_display_name=>'Variable - Large'
,p_display_sequence=>60
,p_report_template_id=>wwv_flow_api.id(12495548550946880181)
,p_css_classes=>'t-AVPList--variableLabelLarge'
,p_group_id=>wwv_flow_api.id(88266187296008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495547450629880177)
,p_theme_id=>42
,p_name=>'RIGHT_ALIGNED_DETAILS'
,p_display_name=>'Right Aligned Details'
,p_display_sequence=>20
,p_report_template_id=>wwv_flow_api.id(12495548550946880181)
,p_css_classes=>'t-AVPList--rightAligned'
,p_group_id=>wwv_flow_api.id(88266643914008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495547619235880177)
,p_theme_id=>42
,p_name=>'LEFT_ALIGNED_DETAILS'
,p_display_name=>'Left Aligned Details'
,p_display_sequence=>10
,p_report_template_id=>wwv_flow_api.id(12495548550946880181)
,p_css_classes=>'t-AVPList--leftAligned'
,p_group_id=>wwv_flow_api.id(88266643914008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495547810758880177)
,p_theme_id=>42
,p_name=>'FIXED_SMALL'
,p_display_name=>'Fixed - Small'
,p_display_sequence=>10
,p_report_template_id=>wwv_flow_api.id(12495548550946880181)
,p_css_classes=>'t-AVPList--fixedLabelSmall'
,p_group_id=>wwv_flow_api.id(88266187296008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495548064828880179)
,p_theme_id=>42
,p_name=>'FIXED_MEDIUM'
,p_display_name=>'Fixed - Medium'
,p_display_sequence=>20
,p_report_template_id=>wwv_flow_api.id(12495548550946880181)
,p_css_classes=>'t-AVPList--fixedLabelMedium'
,p_group_id=>wwv_flow_api.id(88266187296008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495548253342880179)
,p_theme_id=>42
,p_name=>'FIXED_LARGE'
,p_display_name=>'Fixed - Large'
,p_display_sequence=>30
,p_report_template_id=>wwv_flow_api.id(12495548550946880181)
,p_css_classes=>'t-AVPList--fixedLabelLarge'
,p_group_id=>wwv_flow_api.id(88266187296008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495548643163880181)
,p_theme_id=>42
,p_name=>'APPLY_THEME_COLORS'
,p_display_name=>'Apply Theme Colors'
,p_display_sequence=>40
,p_report_template_id=>wwv_flow_api.id(12495551502649880184)
,p_css_classes=>'u-colors'
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495548813608880181)
,p_theme_id=>42
,p_name=>'STACK'
,p_display_name=>'Stack'
,p_display_sequence=>5
,p_report_template_id=>wwv_flow_api.id(12495551502649880184)
,p_css_classes=>'t-MediaList--stack'
,p_group_id=>wwv_flow_api.id(88266643914008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495549082909880182)
,p_theme_id=>42
,p_name=>'SHOW_ICONS'
,p_display_name=>'Show Icons'
,p_display_sequence=>10
,p_report_template_id=>wwv_flow_api.id(12495551502649880184)
,p_css_classes=>'t-MediaList--showIcons'
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495549202810880182)
,p_theme_id=>42
,p_name=>'SHOW_DESCRIPTION'
,p_display_name=>'Show Description'
,p_display_sequence=>20
,p_report_template_id=>wwv_flow_api.id(12495551502649880184)
,p_css_classes=>'t-MediaList--showDesc'
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495549401073880182)
,p_theme_id=>42
,p_name=>'SHOW_BADGES'
,p_display_name=>'Show Badges'
,p_display_sequence=>30
,p_report_template_id=>wwv_flow_api.id(12495551502649880184)
,p_css_classes=>'t-MediaList--showBadges'
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495549638385880182)
,p_theme_id=>42
,p_name=>'LARGE'
,p_display_name=>'Large'
,p_display_sequence=>20
,p_report_template_id=>wwv_flow_api.id(12495551502649880184)
,p_css_classes=>'t-MediaList--large force-fa-lg'
,p_group_id=>wwv_flow_api.id(88268207434008767)
,p_template_types=>'REPORT'
,p_help_text=>'Increases the size of the text and icons in the list.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495550050952880182)
,p_theme_id=>42
,p_name=>'ICONS_SQUARE'
,p_display_name=>'Square'
,p_display_sequence=>20
,p_report_template_id=>wwv_flow_api.id(12495551502649880184)
,p_css_classes=>'t-MediaList--iconsSquare'
,p_group_id=>wwv_flow_api.id(88265823115008767)
,p_template_types=>'REPORT'
,p_help_text=>'The icons are displayed within a square shape.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495550295458880184)
,p_theme_id=>42
,p_name=>'ICONS_ROUNDED'
,p_display_name=>'Rounded Corners'
,p_display_sequence=>10
,p_report_template_id=>wwv_flow_api.id(12495551502649880184)
,p_css_classes=>'t-MediaList--iconsRounded'
,p_group_id=>wwv_flow_api.id(88265823115008767)
,p_template_types=>'REPORT'
,p_help_text=>'The icons are displayed within a square with rounded corners.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495550474540880184)
,p_theme_id=>42
,p_name=>'SPAN_HORIZONTAL'
,p_display_name=>'Span Horizontal'
,p_display_sequence=>50
,p_report_template_id=>wwv_flow_api.id(12495551502649880184)
,p_css_classes=>'t-MediaList--horizontal'
,p_group_id=>wwv_flow_api.id(88266643914008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495550606866880184)
,p_theme_id=>42
,p_name=>'5_COLUMN_GRID'
,p_display_name=>'5 Column Grid'
,p_display_sequence=>40
,p_report_template_id=>wwv_flow_api.id(12495551502649880184)
,p_css_classes=>'t-MediaList--cols t-MediaList--5cols'
,p_group_id=>wwv_flow_api.id(88266643914008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495550824129880184)
,p_theme_id=>42
,p_name=>'4_COLUMN_GRID'
,p_display_name=>'4 Column Grid'
,p_display_sequence=>30
,p_report_template_id=>wwv_flow_api.id(12495551502649880184)
,p_css_classes=>'t-MediaList--cols t-MediaList--4cols'
,p_group_id=>wwv_flow_api.id(88266643914008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495551080312880184)
,p_theme_id=>42
,p_name=>'3_COLUMN_GRID'
,p_display_name=>'3 Column Grid'
,p_display_sequence=>20
,p_report_template_id=>wwv_flow_api.id(12495551502649880184)
,p_css_classes=>'t-MediaList--cols t-MediaList--3cols'
,p_group_id=>wwv_flow_api.id(88266643914008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495551282235880184)
,p_theme_id=>42
,p_name=>'2_COLUMN_GRID'
,p_display_name=>'2 Column Grid'
,p_display_sequence=>10
,p_report_template_id=>wwv_flow_api.id(12495551502649880184)
,p_css_classes=>'t-MediaList--cols t-MediaList--2cols'
,p_group_id=>wwv_flow_api.id(88266643914008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495551602804880184)
,p_theme_id=>42
,p_name=>'COMPACT'
,p_display_name=>'Compact'
,p_display_sequence=>1
,p_report_template_id=>wwv_flow_api.id(12495551963420880184)
,p_css_classes=>'t-Timeline--compact'
,p_group_id=>wwv_flow_api.id(88268588825008767)
,p_template_types=>'REPORT'
,p_help_text=>'Displays a compact version of timeline with smaller text and fewer columns.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495552079578880184)
,p_theme_id=>42
,p_name=>'STYLE_COMPACT'
,p_display_name=>'Compact'
,p_display_sequence=>1
,p_report_template_id=>wwv_flow_api.id(12495555143782880187)
,p_css_classes=>'t-ContentRow--styleCompact'
,p_group_id=>wwv_flow_api.id(88268588825008767)
,p_template_types=>'REPORT'
,p_help_text=>'This option reduces the padding and font sizes to present a compact display of the same information.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495552209678880184)
,p_theme_id=>42
,p_name=>'TITLE_HIDDEN'
,p_display_name=>'Hidden'
,p_display_sequence=>30
,p_report_template_id=>wwv_flow_api.id(12495555143782880187)
,p_css_classes=>'t-ContentRow--hideTitle'
,p_group_id=>wwv_flow_api.id(88262957922008766)
,p_template_types=>'REPORT'
,p_help_text=>'Hides the Title from being rendered on the screen.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495552617879880184)
,p_theme_id=>42
,p_name=>'SELECTION_HIDDEN'
,p_display_name=>'Hidden'
,p_display_sequence=>10
,p_report_template_id=>wwv_flow_api.id(12495555143782880187)
,p_css_classes=>'t-ContentRow--hideSelection'
,p_group_id=>wwv_flow_api.id(88264199873008766)
,p_template_types=>'REPORT'
,p_help_text=>'Hides the Selection column from being rendered on the screen.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495553009304880184)
,p_theme_id=>42
,p_name=>'MISC_HIDDEN'
,p_display_name=>'Hidden'
,p_display_sequence=>50
,p_report_template_id=>wwv_flow_api.id(12495555143782880187)
,p_css_classes=>'t-ContentRow--hideMisc'
,p_group_id=>wwv_flow_api.id(88263819975008766)
,p_template_types=>'REPORT'
,p_help_text=>'Hides the Misc column from being rendered on the screen.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495553414079880185)
,p_theme_id=>42
,p_name=>'ICON_HIDDEN'
,p_display_name=>'Hidden'
,p_display_sequence=>20
,p_report_template_id=>wwv_flow_api.id(12495555143782880187)
,p_css_classes=>'t-ContentRow--hideIcon'
,p_group_id=>wwv_flow_api.id(88263443080008766)
,p_template_types=>'REPORT'
,p_help_text=>'Hides the Icon from being rendered on the screen.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495553881941880185)
,p_theme_id=>42
,p_name=>'DESCRIPTION_HIDDEN'
,p_display_name=>'Hidden'
,p_display_sequence=>40
,p_report_template_id=>wwv_flow_api.id(12495555143782880187)
,p_css_classes=>'t-ContentRow--hideDescription'
,p_group_id=>wwv_flow_api.id(88262608559008766)
,p_template_types=>'REPORT'
,p_help_text=>'Hides the Description from being rendered on the screen.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495554229884880185)
,p_theme_id=>42
,p_name=>'ACTIONS_HIDDEN'
,p_display_name=>'Hidden'
,p_display_sequence=>60
,p_report_template_id=>wwv_flow_api.id(12495555143782880187)
,p_css_classes=>'t-ContentRow--hideActions'
,p_group_id=>wwv_flow_api.id(88262213553008766)
,p_template_types=>'REPORT'
,p_help_text=>'Hides the Actions column from being rendered on the screen.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495554636875880185)
,p_theme_id=>42
,p_name=>'ALIGNMENT_TOP'
,p_display_name=>'Top'
,p_display_sequence=>100
,p_report_template_id=>wwv_flow_api.id(12495555143782880187)
,p_css_classes=>'t-ContentRow--alignTop'
,p_group_id=>wwv_flow_api.id(88265018735008767)
,p_template_types=>'REPORT'
,p_help_text=>'Aligns the content to the top of the row. This is useful when you expect that yours rows will vary in height (e.g. some rows will have longer descriptions than others).'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495555228129880187)
,p_theme_id=>42
,p_name=>'VARIABLE_SMALL'
,p_display_name=>'Variable - Small'
,p_display_sequence=>40
,p_report_template_id=>wwv_flow_api.id(12495557168323880188)
,p_css_classes=>'t-AVPList--variableLabelSmall'
,p_group_id=>wwv_flow_api.id(88266187296008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495555496496880187)
,p_theme_id=>42
,p_name=>'VARIABLE_MEDIUM'
,p_display_name=>'Variable - Medium'
,p_display_sequence=>50
,p_report_template_id=>wwv_flow_api.id(12495557168323880188)
,p_css_classes=>'t-AVPList--variableLabelMedium'
,p_group_id=>wwv_flow_api.id(88266187296008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495555611131880187)
,p_theme_id=>42
,p_name=>'VARIABLE_LARGE'
,p_display_name=>'Variable - Large'
,p_display_sequence=>60
,p_report_template_id=>wwv_flow_api.id(12495557168323880188)
,p_css_classes=>'t-AVPList--variableLabelLarge'
,p_group_id=>wwv_flow_api.id(88266187296008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495555816095880187)
,p_theme_id=>42
,p_name=>'RIGHT_ALIGNED_DETAILS'
,p_display_name=>'Right Aligned Details'
,p_display_sequence=>20
,p_report_template_id=>wwv_flow_api.id(12495557168323880188)
,p_css_classes=>'t-AVPList--rightAligned'
,p_group_id=>wwv_flow_api.id(88266643914008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495556005155880187)
,p_theme_id=>42
,p_name=>'LEFT_ALIGNED_DETAILS'
,p_display_name=>'Left Aligned Details'
,p_display_sequence=>10
,p_report_template_id=>wwv_flow_api.id(12495557168323880188)
,p_css_classes=>'t-AVPList--leftAligned'
,p_group_id=>wwv_flow_api.id(88266643914008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495556214683880187)
,p_theme_id=>42
,p_name=>'FIXED_SMALL'
,p_display_name=>'Fixed - Small'
,p_display_sequence=>10
,p_report_template_id=>wwv_flow_api.id(12495557168323880188)
,p_css_classes=>'t-AVPList--fixedLabelSmall'
,p_group_id=>wwv_flow_api.id(88266187296008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495556449860880187)
,p_theme_id=>42
,p_name=>'FIXED_MEDIUM'
,p_display_name=>'Fixed - Medium'
,p_display_sequence=>20
,p_report_template_id=>wwv_flow_api.id(12495557168323880188)
,p_css_classes=>'t-AVPList--fixedLabelMedium'
,p_group_id=>wwv_flow_api.id(88266187296008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495556655999880187)
,p_theme_id=>42
,p_name=>'FIXED_LARGE'
,p_display_name=>'Fixed - Large'
,p_display_sequence=>30
,p_report_template_id=>wwv_flow_api.id(12495557168323880188)
,p_css_classes=>'t-AVPList--fixedLabelLarge'
,p_group_id=>wwv_flow_api.id(88266187296008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495557231685880188)
,p_theme_id=>42
,p_name=>'VERTICALBORDERS'
,p_display_name=>'Vertical Only'
,p_display_sequence=>20
,p_report_template_id=>wwv_flow_api.id(12495559701953880190)
,p_css_classes=>'t-Report--verticalBorders'
,p_group_id=>wwv_flow_api.id(88267400402008767)
,p_template_types=>'REPORT'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495557458025880188)
,p_theme_id=>42
,p_name=>'STRETCHREPORT'
,p_display_name=>'Stretch Report'
,p_display_sequence=>10
,p_report_template_id=>wwv_flow_api.id(12495559701953880190)
,p_css_classes=>'t-Report--stretch'
,p_template_types=>'REPORT'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495557699371880188)
,p_theme_id=>42
,p_name=>'ALTROWCOLORSDISABLE'
,p_display_name=>'Disable'
,p_display_sequence=>20
,p_report_template_id=>wwv_flow_api.id(12495559701953880190)
,p_css_classes=>'t-Report--staticRowColors'
,p_group_id=>wwv_flow_api.id(88260201185008765)
,p_template_types=>'REPORT'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495557860589880188)
,p_theme_id=>42
,p_name=>'ROWHIGHLIGHTDISABLE'
,p_display_name=>'Disable'
,p_display_sequence=>20
,p_report_template_id=>wwv_flow_api.id(12495559701953880190)
,p_css_classes=>'t-Report--rowHighlightOff'
,p_group_id=>wwv_flow_api.id(88267830177008767)
,p_template_types=>'REPORT'
,p_help_text=>'Disable row highlighting on mouse over'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495558081907880188)
,p_theme_id=>42
,p_name=>'ENABLE'
,p_display_name=>'Enable'
,p_display_sequence=>10
,p_report_template_id=>wwv_flow_api.id(12495559701953880190)
,p_css_classes=>'t-Report--rowHighlight'
,p_group_id=>wwv_flow_api.id(88267830177008767)
,p_template_types=>'REPORT'
,p_help_text=>'Enable row highlighting on mouse over'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495558478229880188)
,p_theme_id=>42
,p_name=>'REMOVEALLBORDERS'
,p_display_name=>'No Borders'
,p_display_sequence=>30
,p_report_template_id=>wwv_flow_api.id(12495559701953880190)
,p_css_classes=>'t-Report--noBorders'
,p_group_id=>wwv_flow_api.id(88267400402008767)
,p_template_types=>'REPORT'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495558619467880190)
,p_theme_id=>42
,p_name=>'REMOVEOUTERBORDERS'
,p_display_name=>'No Outer Borders'
,p_display_sequence=>40
,p_report_template_id=>wwv_flow_api.id(12495559701953880190)
,p_css_classes=>'t-Report--inline'
,p_group_id=>wwv_flow_api.id(88267400402008767)
,p_template_types=>'REPORT'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495558807878880190)
,p_theme_id=>42
,p_name=>'HORIZONTALBORDERS'
,p_display_name=>'Horizontal Only'
,p_display_sequence=>20
,p_report_template_id=>wwv_flow_api.id(12495559701953880190)
,p_css_classes=>'t-Report--horizontalBorders'
,p_group_id=>wwv_flow_api.id(88267400402008767)
,p_template_types=>'REPORT'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495559298261880190)
,p_theme_id=>42
,p_name=>'ALTROWCOLORSENABLE'
,p_display_name=>'Enable'
,p_display_sequence=>10
,p_report_template_id=>wwv_flow_api.id(12495559701953880190)
,p_css_classes=>'t-Report--altRowsDefault'
,p_group_id=>wwv_flow_api.id(88260201185008765)
,p_template_types=>'REPORT'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495560094146880192)
,p_theme_id=>42
,p_name=>'ICONS_SQUARE'
,p_display_name=>'Square'
,p_display_sequence=>20
,p_report_template_id=>wwv_flow_api.id(12495561145534880193)
,p_css_classes=>'t-Comments--iconsSquare'
,p_group_id=>wwv_flow_api.id(88265823115008767)
,p_template_types=>'REPORT'
,p_help_text=>'The icons are displayed within a square shape.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495560283734880192)
,p_theme_id=>42
,p_name=>'ICONS_ROUNDED'
,p_display_name=>'Rounded Corners'
,p_display_sequence=>10
,p_report_template_id=>wwv_flow_api.id(12495561145534880193)
,p_css_classes=>'t-Comments--iconsRounded'
,p_group_id=>wwv_flow_api.id(88265823115008767)
,p_template_types=>'REPORT'
,p_help_text=>'The icons are displayed within a square with rounded corners.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495560498971880192)
,p_theme_id=>42
,p_name=>'SPEECH_BUBBLES'
,p_display_name=>'Speech Bubbles'
,p_display_sequence=>20
,p_report_template_id=>wwv_flow_api.id(12495561145534880193)
,p_css_classes=>'t-Comments--chat'
,p_group_id=>wwv_flow_api.id(88264558272008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495560650598880192)
,p_theme_id=>42
,p_name=>'BASIC'
,p_display_name=>'Basic'
,p_display_sequence=>10
,p_report_template_id=>wwv_flow_api.id(12495561145534880193)
,p_css_classes=>'t-Comments--basic'
,p_group_id=>wwv_flow_api.id(88264558272008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495561206143880193)
,p_theme_id=>42
,p_name=>'USE_THEME_COLORS'
,p_display_name=>'Apply Theme Colors'
,p_display_sequence=>10
,p_report_template_id=>wwv_flow_api.id(12495566507385880202)
,p_css_classes=>'u-colors'
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495561439726880193)
,p_theme_id=>42
,p_name=>'SPAN_HORIZONTALLY'
,p_display_name=>'Span Horizontally'
,p_display_sequence=>70
,p_report_template_id=>wwv_flow_api.id(12495566507385880202)
,p_css_classes=>'t-Cards--spanHorizontally'
,p_group_id=>wwv_flow_api.id(88266643914008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495561697325880193)
,p_theme_id=>42
,p_name=>'ICONS_SQUARE'
,p_display_name=>'Square'
,p_display_sequence=>20
,p_report_template_id=>wwv_flow_api.id(12495566507385880202)
,p_css_classes=>'t-Cards--iconsSquare'
,p_group_id=>wwv_flow_api.id(88265823115008767)
,p_template_types=>'REPORT'
,p_help_text=>'The icons are displayed within a square shape.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495561825119880193)
,p_theme_id=>42
,p_name=>'ICONS_ROUNDED'
,p_display_name=>'Rounded Corners'
,p_display_sequence=>10
,p_report_template_id=>wwv_flow_api.id(12495566507385880202)
,p_css_classes=>'t-Cards--iconsRounded'
,p_group_id=>wwv_flow_api.id(88265823115008767)
,p_template_types=>'REPORT'
,p_help_text=>'The icons are displayed within a square with rounded corners.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495562203691880193)
,p_theme_id=>42
,p_name=>'HIDDEN_BODY_TEXT'
,p_display_name=>'Hidden'
,p_display_sequence=>50
,p_report_template_id=>wwv_flow_api.id(12495566507385880202)
,p_css_classes=>'t-Cards--hideBody'
,p_group_id=>wwv_flow_api.id(88261445812008766)
,p_template_types=>'REPORT'
,p_help_text=>'This option hides the card body which contains description and subtext.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495562438492880193)
,p_theme_id=>42
,p_name=>'FLOAT'
,p_display_name=>'Float'
,p_display_sequence=>60
,p_report_template_id=>wwv_flow_api.id(12495566507385880202)
,p_css_classes=>'t-Cards--float'
,p_group_id=>wwv_flow_api.id(88266643914008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495562621910880193)
,p_theme_id=>42
,p_name=>'BLOCK'
,p_display_name=>'Block'
,p_display_sequence=>40
,p_report_template_id=>wwv_flow_api.id(12495566507385880202)
,p_css_classes=>'t-Cards--featured t-Cards--block force-fa-lg'
,p_group_id=>wwv_flow_api.id(88268588825008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495562862622880193)
,p_theme_id=>42
,p_name=>'FEATURED'
,p_display_name=>'Featured'
,p_display_sequence=>30
,p_report_template_id=>wwv_flow_api.id(12495566507385880202)
,p_css_classes=>'t-Cards--featured force-fa-lg'
,p_group_id=>wwv_flow_api.id(88268588825008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495563097453880193)
,p_theme_id=>42
,p_name=>'DISPLAY_SUBTITLE'
,p_display_name=>'Display Subtitle'
,p_display_sequence=>20
,p_report_template_id=>wwv_flow_api.id(12495566507385880202)
,p_css_classes=>'t-Cards--displaySubtitle'
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495563252910880193)
,p_theme_id=>42
,p_name=>'DISPLAY_INITIALS'
,p_display_name=>'Display Initials'
,p_display_sequence=>20
,p_report_template_id=>wwv_flow_api.id(12495566507385880202)
,p_css_classes=>'t-Cards--displayInitials'
,p_group_id=>wwv_flow_api.id(88265375732008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495563404221880193)
,p_theme_id=>42
,p_name=>'DISPLAY_ICONS'
,p_display_name=>'Display Icons'
,p_display_sequence=>10
,p_report_template_id=>wwv_flow_api.id(12495566507385880202)
,p_css_classes=>'t-Cards--displayIcons'
,p_group_id=>wwv_flow_api.id(88265375732008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495563865852880198)
,p_theme_id=>42
,p_name=>'4_LINES'
,p_display_name=>'4 Lines'
,p_display_sequence=>30
,p_report_template_id=>wwv_flow_api.id(12495566507385880202)
,p_css_classes=>'t-Cards--desc-4ln'
,p_group_id=>wwv_flow_api.id(88261445812008766)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495564063832880198)
,p_theme_id=>42
,p_name=>'3_LINES'
,p_display_name=>'3 Lines'
,p_display_sequence=>20
,p_report_template_id=>wwv_flow_api.id(12495566507385880202)
,p_css_classes=>'t-Cards--desc-3ln'
,p_group_id=>wwv_flow_api.id(88261445812008766)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495564226052880198)
,p_theme_id=>42
,p_name=>'2_LINES'
,p_display_name=>'2 Lines'
,p_display_sequence=>10
,p_report_template_id=>wwv_flow_api.id(12495566507385880202)
,p_css_classes=>'t-Cards--desc-2ln'
,p_group_id=>wwv_flow_api.id(88261445812008766)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495564645096880198)
,p_theme_id=>42
,p_name=>'COMPACT'
,p_display_name=>'Compact'
,p_display_sequence=>20
,p_report_template_id=>wwv_flow_api.id(12495566507385880202)
,p_css_classes=>'t-Cards--compact'
,p_group_id=>wwv_flow_api.id(88268588825008767)
,p_template_types=>'REPORT'
,p_help_text=>'Use this option when you want to show smaller cards.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495564841403880198)
,p_theme_id=>42
,p_name=>'2_COLUMNS'
,p_display_name=>'2 Columns'
,p_display_sequence=>15
,p_report_template_id=>wwv_flow_api.id(12495566507385880202)
,p_css_classes=>'t-Cards--cols'
,p_group_id=>wwv_flow_api.id(88266643914008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495565030673880199)
,p_theme_id=>42
,p_name=>'BASIC'
,p_display_name=>'Basic'
,p_display_sequence=>10
,p_report_template_id=>wwv_flow_api.id(12495566507385880202)
,p_css_classes=>'t-Cards--basic'
,p_group_id=>wwv_flow_api.id(88268588825008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495565255452880199)
,p_theme_id=>42
,p_name=>'CARD_RAISE_CARD'
,p_display_name=>'Raise Card'
,p_display_sequence=>20
,p_report_template_id=>wwv_flow_api.id(12495566507385880202)
,p_css_classes=>'t-Cards--animRaiseCard'
,p_group_id=>wwv_flow_api.id(88260559781008765)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495565419981880201)
,p_theme_id=>42
,p_name=>'CARDS_COLOR_FILL'
,p_display_name=>'Color Fill'
,p_display_sequence=>10
,p_report_template_id=>wwv_flow_api.id(12495566507385880202)
,p_css_classes=>'t-Cards--animColorFill'
,p_group_id=>wwv_flow_api.id(88260559781008765)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495565867405880201)
,p_theme_id=>42
,p_name=>'5_COLUMNS'
,p_display_name=>'5 Columns'
,p_display_sequence=>50
,p_report_template_id=>wwv_flow_api.id(12495566507385880202)
,p_css_classes=>'t-Cards--5cols'
,p_group_id=>wwv_flow_api.id(88266643914008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495566092868880201)
,p_theme_id=>42
,p_name=>'4_COLUMNS'
,p_display_name=>'4 Columns'
,p_display_sequence=>30
,p_report_template_id=>wwv_flow_api.id(12495566507385880202)
,p_css_classes=>'t-Cards--4cols'
,p_group_id=>wwv_flow_api.id(88266643914008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495566224806880201)
,p_theme_id=>42
,p_name=>'3_COLUMNS'
,p_display_name=>'3 Columns'
,p_display_sequence=>20
,p_report_template_id=>wwv_flow_api.id(12495566507385880202)
,p_css_classes=>'t-Cards--3cols'
,p_group_id=>wwv_flow_api.id(88266643914008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495566611054880202)
,p_theme_id=>42
,p_name=>'APPLY_THEME_COLORS'
,p_display_name=>'Apply Theme Colors'
,p_display_sequence=>10
,p_report_template_id=>wwv_flow_api.id(12495570578125880206)
,p_css_classes=>'u-colors'
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495566844954880202)
,p_theme_id=>42
,p_name=>'128PX'
,p_display_name=>'128px'
,p_display_sequence=>50
,p_report_template_id=>wwv_flow_api.id(12495570578125880206)
,p_css_classes=>'t-BadgeList--xxlarge'
,p_group_id=>wwv_flow_api.id(88261023092008766)
,p_template_types=>'REPORT'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495567097788880202)
,p_theme_id=>42
,p_name=>'96PX'
,p_display_name=>'96px'
,p_display_sequence=>40
,p_report_template_id=>wwv_flow_api.id(12495570578125880206)
,p_css_classes=>'t-BadgeList--xlarge'
,p_group_id=>wwv_flow_api.id(88261023092008766)
,p_template_types=>'REPORT'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495567254741880202)
,p_theme_id=>42
,p_name=>'STACKED'
,p_display_name=>'Stacked'
,p_display_sequence=>10
,p_report_template_id=>wwv_flow_api.id(12495570578125880206)
,p_css_classes=>'t-BadgeList--stacked'
,p_group_id=>wwv_flow_api.id(88266643914008767)
,p_template_types=>'REPORT'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495567477733880202)
,p_theme_id=>42
,p_name=>'32PX'
,p_display_name=>'32px'
,p_display_sequence=>10
,p_report_template_id=>wwv_flow_api.id(12495570578125880206)
,p_css_classes=>'t-BadgeList--small'
,p_group_id=>wwv_flow_api.id(88261023092008766)
,p_template_types=>'REPORT'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495567657760880202)
,p_theme_id=>42
,p_name=>'48PX'
,p_display_name=>'48px'
,p_display_sequence=>20
,p_report_template_id=>wwv_flow_api.id(12495570578125880206)
,p_css_classes=>'t-BadgeList--medium'
,p_group_id=>wwv_flow_api.id(88261023092008766)
,p_template_types=>'REPORT'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495567871477880204)
,p_theme_id=>42
,p_name=>'64PX'
,p_display_name=>'64px'
,p_display_sequence=>30
,p_report_template_id=>wwv_flow_api.id(12495570578125880206)
,p_css_classes=>'t-BadgeList--large'
,p_group_id=>wwv_flow_api.id(88261023092008766)
,p_template_types=>'REPORT'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495568299015880204)
,p_theme_id=>42
,p_name=>'FLOATITEMS'
,p_display_name=>'Float Items'
,p_display_sequence=>70
,p_report_template_id=>wwv_flow_api.id(12495570578125880206)
,p_css_classes=>'t-BadgeList--float'
,p_group_id=>wwv_flow_api.id(88266643914008767)
,p_template_types=>'REPORT'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495568492129880204)
,p_theme_id=>42
,p_name=>'FLEXIBLEBOX'
,p_display_name=>'Flexible Box'
,p_display_sequence=>80
,p_report_template_id=>wwv_flow_api.id(12495570578125880206)
,p_css_classes=>'t-BadgeList--flex'
,p_group_id=>wwv_flow_api.id(88266643914008767)
,p_template_types=>'REPORT'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495568617845880204)
,p_theme_id=>42
,p_name=>'FIXED'
,p_display_name=>'Span Horizontally'
,p_display_sequence=>60
,p_report_template_id=>wwv_flow_api.id(12495570578125880206)
,p_css_classes=>'t-BadgeList--fixed'
,p_group_id=>wwv_flow_api.id(88266643914008767)
,p_template_types=>'REPORT'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495568891525880204)
,p_theme_id=>42
,p_name=>'GRID'
,p_display_name=>'Grid'
,p_display_sequence=>30
,p_report_template_id=>wwv_flow_api.id(12495570578125880206)
,p_css_classes=>'t-BadgeList--dash'
,p_group_id=>wwv_flow_api.id(88268588825008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495569022701880204)
,p_theme_id=>42
,p_name=>'5COLUMNGRID'
,p_display_name=>'5 Column Grid'
,p_display_sequence=>50
,p_report_template_id=>wwv_flow_api.id(12495570578125880206)
,p_css_classes=>'t-BadgeList--cols t-BadgeList--5cols'
,p_group_id=>wwv_flow_api.id(88266643914008767)
,p_template_types=>'REPORT'
,p_is_advanced=>'N'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495569282312880204)
,p_theme_id=>42
,p_name=>'4COLUMNGRID'
,p_display_name=>'4 Column Grid'
,p_display_sequence=>40
,p_report_template_id=>wwv_flow_api.id(12495570578125880206)
,p_css_classes=>'t-BadgeList--cols t-BadgeList--4cols'
,p_group_id=>wwv_flow_api.id(88266643914008767)
,p_template_types=>'REPORT'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495569490227880204)
,p_theme_id=>42
,p_name=>'3COLUMNGRID'
,p_display_name=>'3 Column Grid'
,p_display_sequence=>30
,p_report_template_id=>wwv_flow_api.id(12495570578125880206)
,p_css_classes=>'t-BadgeList--cols t-BadgeList--3cols'
,p_group_id=>wwv_flow_api.id(88266643914008767)
,p_template_types=>'REPORT'
,p_help_text=>'Arrange badges in a 3 column grid'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495569638054880204)
,p_theme_id=>42
,p_name=>'2COLUMNGRID'
,p_display_name=>'2 Column Grid'
,p_display_sequence=>20
,p_report_template_id=>wwv_flow_api.id(12495570578125880206)
,p_css_classes=>'t-BadgeList--cols'
,p_group_id=>wwv_flow_api.id(88266643914008767)
,p_template_types=>'REPORT'
,p_help_text=>'Arrange badges in a two column grid'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495570041442880206)
,p_theme_id=>42
,p_name=>'CIRCULAR'
,p_display_name=>'Circular'
,p_display_sequence=>20
,p_report_template_id=>wwv_flow_api.id(12495570578125880206)
,p_css_classes=>'t-BadgeList--circular'
,p_group_id=>wwv_flow_api.id(88268588825008767)
,p_template_types=>'REPORT'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495570856484880213)
,p_theme_id=>42
,p_name=>'SHOW_TITLE'
,p_display_name=>'Show Title'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495572013166880213)
,p_css_classes=>'t-Wizard--showTitle'
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495571036749880213)
,p_theme_id=>42
,p_name=>'HIDEXSMALLSCREENS'
,p_display_name=>'X Small Screens (Mobile)'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495572013166880213)
,p_css_classes=>'t-Wizard--hideStepsXSmall'
,p_group_id=>wwv_flow_api.id(88253046311008764)
,p_template_types=>'REGION'
,p_help_text=>'Hides the wizard progress steps for screens that are smaller than 768px wide.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495571238093880213)
,p_theme_id=>42
,p_name=>'HIDESMALLSCREENS'
,p_display_name=>'Small Screens (Tablet)'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495572013166880213)
,p_css_classes=>'t-Wizard--hideStepsSmall'
,p_group_id=>wwv_flow_api.id(88253046311008764)
,p_template_types=>'REGION'
,p_help_text=>'Hides the wizard progress steps for screens that are smaller than 768px wide.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495572105966880218)
,p_theme_id=>42
,p_name=>'REGION_HEADER_VISIBLE'
,p_display_name=>'Use Region Title'
,p_display_sequence=>1
,p_region_template_id=>wwv_flow_api.id(12495573047450880221)
,p_css_classes=>'t-BreadcrumbRegion--useRegionTitle'
,p_group_id=>wwv_flow_api.id(88257822764008765)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495572339255880218)
,p_theme_id=>42
,p_name=>'GET_TITLE_FROM_BREADCRUMB'
,p_display_name=>'Use Current Breadcrumb Entry'
,p_display_sequence=>1
,p_region_template_id=>wwv_flow_api.id(12495573047450880221)
,p_css_classes=>'t-BreadcrumbRegion--useBreadcrumbTitle'
,p_group_id=>wwv_flow_api.id(88257822764008765)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495572592954880218)
,p_theme_id=>42
,p_name=>'HIDE_BREADCRUMB'
,p_display_name=>'Show Breadcrumbs'
,p_display_sequence=>1
,p_region_template_id=>wwv_flow_api.id(12495573047450880221)
,p_css_classes=>'t-BreadcrumbRegion--showBreadcrumb'
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495572740683880218)
,p_theme_id=>42
,p_name=>'USE_COMPACT_STYLE'
,p_display_name=>'Use Compact Style'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495573047450880221)
,p_css_classes=>'t-BreadcrumbRegion--compactTitle'
,p_template_types=>'REGION'
,p_help_text=>'Uses a compact style for the breadcrumbs.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495573199090880221)
,p_theme_id=>42
,p_name=>'TABS_SMALL'
,p_display_name=>'Small'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495575615770880223)
,p_css_classes=>'t-TabsRegion-mod--small'
,p_group_id=>wwv_flow_api.id(88258964959008765)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495573394794880221)
,p_theme_id=>42
,p_name=>'SIMPLE'
,p_display_name=>'Simple'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495575615770880223)
,p_css_classes=>'t-TabsRegion-mod--simple'
,p_group_id=>wwv_flow_api.id(88259351612008765)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495573516866880223)
,p_theme_id=>42
,p_name=>'PILL'
,p_display_name=>'Pill'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495575615770880223)
,p_css_classes=>'t-TabsRegion-mod--pill'
,p_group_id=>wwv_flow_api.id(88259351612008765)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495573968526880223)
,p_theme_id=>42
,p_name=>'TABSLARGE'
,p_display_name=>'Large'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495575615770880223)
,p_css_classes=>'t-TabsRegion-mod--large'
,p_group_id=>wwv_flow_api.id(88258964959008765)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495574354715880223)
,p_theme_id=>42
,p_name=>'FILL_TAB_LABELS'
,p_display_name=>'Fill Tab Labels'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495575615770880223)
,p_css_classes=>'t-TabsRegion-mod--fillLabels'
,p_group_id=>wwv_flow_api.id(88255803841008764)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495574742904880223)
,p_theme_id=>42
,p_name=>'REMEMBER_ACTIVE_TAB'
,p_display_name=>'Remember Active Tab'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495575615770880223)
,p_css_classes=>'js-useLocalStorage'
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495575725402880223)
,p_theme_id=>42
,p_name=>'TEXT_CONTENT'
,p_display_name=>'Text Content'
,p_display_sequence=>40
,p_region_template_id=>wwv_flow_api.id(12495582446800880234)
,p_css_classes=>'t-Region--textContent'
,p_group_id=>wwv_flow_api.id(88258647145008765)
,p_template_types=>'REGION'
,p_help_text=>'Useful for displaying primarily text-based content, such as FAQs and more.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495575977296880223)
,p_theme_id=>42
,p_name=>'STACKED'
,p_display_name=>'Stack Region'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495582446800880234)
,p_css_classes=>'t-Region--stacked'
,p_group_id=>wwv_flow_api.id(88258647145008765)
,p_template_types=>'REGION'
,p_help_text=>'Removes side borders and shadows, and can be useful for accordions and regions that need to be grouped together vertically.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495576186628880224)
,p_theme_id=>42
,p_name=>'SHOW_REGION_ICON'
,p_display_name=>'Show Region Icon'
,p_display_sequence=>30
,p_region_template_id=>wwv_flow_api.id(12495582446800880234)
,p_css_classes=>'t-Region--showIcon'
,p_template_types=>'REGION'
,p_help_text=>'Displays the region icon in the region header beside the region title'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495576355854880224)
,p_theme_id=>42
,p_name=>'SCROLLBODY'
,p_display_name=>'Scroll - Default'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495582446800880234)
,p_css_classes=>'t-Region--scrollBody'
,p_group_id=>wwv_flow_api.id(88248951551008763)
,p_template_types=>'REGION'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495576597046880224)
,p_theme_id=>42
,p_name=>'HIDDENHEADERNOAT'
,p_display_name=>'Hidden'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495582446800880234)
,p_css_classes=>'t-Region--removeHeader'
,p_group_id=>wwv_flow_api.id(88252596160008764)
,p_template_types=>'REGION'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495576768921880227)
,p_theme_id=>42
,p_name=>'REMOVE_UI_DECORATION'
,p_display_name=>'Remove UI Decoration'
,p_display_sequence=>30
,p_region_template_id=>wwv_flow_api.id(12495582446800880234)
,p_css_classes=>'t-Region--noUI'
,p_group_id=>wwv_flow_api.id(88258647145008765)
,p_template_types=>'REGION'
,p_help_text=>'Removes UI decoration (borders, backgrounds, shadows, etc) from the region.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495576991918880227)
,p_theme_id=>42
,p_name=>'NOBODYPADDING'
,p_display_name=>'Remove Body Padding'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495582446800880234)
,p_css_classes=>'t-Region--noPadding'
,p_template_types=>'REGION'
,p_help_text=>'Removes padding from region body.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495577170820880227)
,p_theme_id=>42
,p_name=>'NOBORDER'
,p_display_name=>'Remove Borders'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495582446800880234)
,p_css_classes=>'t-Region--noBorder'
,p_group_id=>wwv_flow_api.id(88258647145008765)
,p_template_types=>'REGION'
,p_help_text=>'Removes borders from the region.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495577347312880227)
,p_theme_id=>42
,p_name=>'HIDEREGIONHEADER'
,p_display_name=>'Hidden but accessible'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495582446800880234)
,p_css_classes=>'t-Region--hideHeader'
,p_group_id=>wwv_flow_api.id(88252596160008764)
,p_template_types=>'REGION'
,p_help_text=>'This option will hide the region header.  Note that the region title will still be audible for Screen Readers. Buttons placed in the region header will be hidden and inaccessible.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495577502198880229)
,p_theme_id=>42
,p_name=>'HIDEOVERFLOW'
,p_display_name=>'Hide'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495582446800880234)
,p_css_classes=>'t-Region--hiddenOverflow'
,p_group_id=>wwv_flow_api.id(88248951551008763)
,p_template_types=>'REGION'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495577776616880229)
,p_theme_id=>42
,p_name=>'ACCENT_9'
,p_display_name=>'Accent 9'
,p_display_sequence=>90
,p_region_template_id=>wwv_flow_api.id(12495582446800880234)
,p_css_classes=>'t-Region--accent9'
,p_group_id=>wwv_flow_api.id(88246153834008762)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495577921451880229)
,p_theme_id=>42
,p_name=>'ACCENT_8'
,p_display_name=>'Accent 8'
,p_display_sequence=>80
,p_region_template_id=>wwv_flow_api.id(12495582446800880234)
,p_css_classes=>'t-Region--accent8'
,p_group_id=>wwv_flow_api.id(88246153834008762)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495578113952880229)
,p_theme_id=>42
,p_name=>'ACCENT_7'
,p_display_name=>'Accent 7'
,p_display_sequence=>70
,p_region_template_id=>wwv_flow_api.id(12495582446800880234)
,p_css_classes=>'t-Region--accent7'
,p_group_id=>wwv_flow_api.id(88246153834008762)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495578398557880229)
,p_theme_id=>42
,p_name=>'ACCENT_6'
,p_display_name=>'Accent 6'
,p_display_sequence=>60
,p_region_template_id=>wwv_flow_api.id(12495582446800880234)
,p_css_classes=>'t-Region--accent6'
,p_group_id=>wwv_flow_api.id(88246153834008762)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495578544998880229)
,p_theme_id=>42
,p_name=>'ACCENT_5'
,p_display_name=>'Accent 5'
,p_display_sequence=>50
,p_region_template_id=>wwv_flow_api.id(12495582446800880234)
,p_css_classes=>'t-Region--accent5'
,p_group_id=>wwv_flow_api.id(88246153834008762)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495578754356880229)
,p_theme_id=>42
,p_name=>'ACCENT_4'
,p_display_name=>'Accent 4'
,p_display_sequence=>40
,p_region_template_id=>wwv_flow_api.id(12495582446800880234)
,p_css_classes=>'t-Region--accent4'
,p_group_id=>wwv_flow_api.id(88246153834008762)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495578954875880229)
,p_theme_id=>42
,p_name=>'ACCENT_3'
,p_display_name=>'Accent 3'
,p_display_sequence=>30
,p_region_template_id=>wwv_flow_api.id(12495582446800880234)
,p_css_classes=>'t-Region--accent3'
,p_group_id=>wwv_flow_api.id(88246153834008762)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495579129499880229)
,p_theme_id=>42
,p_name=>'ACCENT_2'
,p_display_name=>'Accent 2'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495582446800880234)
,p_css_classes=>'t-Region--accent2'
,p_group_id=>wwv_flow_api.id(88246153834008762)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495579307653880232)
,p_theme_id=>42
,p_name=>'ACCENT_15'
,p_display_name=>'Accent 15'
,p_display_sequence=>150
,p_region_template_id=>wwv_flow_api.id(12495582446800880234)
,p_css_classes=>'t-Region--accent15'
,p_group_id=>wwv_flow_api.id(88246153834008762)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495579573857880232)
,p_theme_id=>42
,p_name=>'ACCENT_14'
,p_display_name=>'Accent 14'
,p_display_sequence=>140
,p_region_template_id=>wwv_flow_api.id(12495582446800880234)
,p_css_classes=>'t-Region--accent14'
,p_group_id=>wwv_flow_api.id(88246153834008762)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495579715347880232)
,p_theme_id=>42
,p_name=>'ACCENT_13'
,p_display_name=>'Accent 13'
,p_display_sequence=>130
,p_region_template_id=>wwv_flow_api.id(12495582446800880234)
,p_css_classes=>'t-Region--accent13'
,p_group_id=>wwv_flow_api.id(88246153834008762)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495579929707880232)
,p_theme_id=>42
,p_name=>'ACCENT_12'
,p_display_name=>'Accent 12'
,p_display_sequence=>120
,p_region_template_id=>wwv_flow_api.id(12495582446800880234)
,p_css_classes=>'t-Region--accent12'
,p_group_id=>wwv_flow_api.id(88246153834008762)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495580137758880232)
,p_theme_id=>42
,p_name=>'ACCENT_11'
,p_display_name=>'Accent 11'
,p_display_sequence=>110
,p_region_template_id=>wwv_flow_api.id(12495582446800880234)
,p_css_classes=>'t-Region--accent11'
,p_group_id=>wwv_flow_api.id(88246153834008762)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495580348451880232)
,p_theme_id=>42
,p_name=>'ACCENT_10'
,p_display_name=>'Accent 10'
,p_display_sequence=>100
,p_region_template_id=>wwv_flow_api.id(12495582446800880234)
,p_css_classes=>'t-Region--accent10'
,p_group_id=>wwv_flow_api.id(88246153834008762)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495580551726880232)
,p_theme_id=>42
,p_name=>'ACCENT_1'
,p_display_name=>'Accent 1'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495582446800880234)
,p_css_classes=>'t-Region--accent1'
,p_group_id=>wwv_flow_api.id(88246153834008762)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495580728391880232)
,p_theme_id=>42
,p_name=>'SHOW_MAXIMIZE_BUTTON'
,p_display_name=>'Show Maximize Button'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495582446800880234)
,p_css_classes=>'js-showMaximizeButton'
,p_template_types=>'REGION'
,p_help_text=>'Displays a button in the Region Header to maximize the region. Clicking this button will toggle the maximize state and stretch the region to fill the screen.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495580993132880232)
,p_theme_id=>42
,p_name=>'640PX'
,p_display_name=>'640px'
,p_display_sequence=>40
,p_region_template_id=>wwv_flow_api.id(12495582446800880234)
,p_css_classes=>'i-h640'
,p_group_id=>wwv_flow_api.id(88248561281008762)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495581167369880232)
,p_theme_id=>42
,p_name=>'480PX'
,p_display_name=>'480px'
,p_display_sequence=>30
,p_region_template_id=>wwv_flow_api.id(12495582446800880234)
,p_css_classes=>'i-h480'
,p_group_id=>wwv_flow_api.id(88248561281008762)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495581302495880232)
,p_theme_id=>42
,p_name=>'320PX'
,p_display_name=>'320px'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495582446800880234)
,p_css_classes=>'i-h320'
,p_group_id=>wwv_flow_api.id(88248561281008762)
,p_template_types=>'REGION'
,p_help_text=>'Sets region body height to 320px.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495581521331880232)
,p_theme_id=>42
,p_name=>'240PX'
,p_display_name=>'240px'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495582446800880234)
,p_css_classes=>'i-h240'
,p_group_id=>wwv_flow_api.id(88248561281008762)
,p_template_types=>'REGION'
,p_help_text=>'Sets region body height to 240px.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495582533658880234)
,p_theme_id=>42
,p_name=>'LOGIN_HEADER_TITLE'
,p_display_name=>'Title'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495583796584880235)
,p_css_classes=>'t-Login-region--headerTitle'
,p_group_id=>wwv_flow_api.id(88256208344008764)
,p_template_types=>'REGION'
,p_help_text=>'Displays only the Region Title in the Login region.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495582752894880234)
,p_theme_id=>42
,p_name=>'LOGIN_HEADER_ICON'
,p_display_name=>'Icon'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495583796584880235)
,p_css_classes=>'t-Login-region--headerIcon'
,p_group_id=>wwv_flow_api.id(88256208344008764)
,p_template_types=>'REGION'
,p_help_text=>'Displays only the Region Icon in the Login region.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495582942876880235)
,p_theme_id=>42
,p_name=>'LOGO_HEADER_HIDDEN'
,p_display_name=>'Hidden'
,p_display_sequence=>30
,p_region_template_id=>wwv_flow_api.id(12495583796584880235)
,p_css_classes=>'t-Login-region--headerHidden'
,p_group_id=>wwv_flow_api.id(88256208344008764)
,p_template_types=>'REGION'
,p_help_text=>'Hides both the Region Icon and Title from the Login region.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495583800483880235)
,p_theme_id=>42
,p_name=>'REMOVEBORDERS'
,p_display_name=>'Remove Borders'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495584334308880235)
,p_css_classes=>'t-IRR-region--noBorders'
,p_template_types=>'REGION'
,p_help_text=>'Removes borders around the Interactive Report'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495584057238880235)
,p_theme_id=>42
,p_name=>'SHOW_MAXIMIZE_BUTTON'
,p_display_name=>'Show Maximize Button'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495584334308880235)
,p_css_classes=>'js-showMaximizeButton'
,p_template_types=>'REGION'
,p_help_text=>'Displays a button in the Interactive Reports toolbar to maximize the report. Clicking this button will toggle the maximize state and stretch the report to fill the screen.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495584485392880235)
,p_theme_id=>42
,p_name=>'REMOVE_BODY_PADDING'
,p_display_name=>'Remove Body Padding'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495587659835880238)
,p_css_classes=>'t-DialogRegion--noPadding'
,p_template_types=>'REGION'
,p_help_text=>'Removes the padding around the region body.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495584616124880235)
,p_theme_id=>42
,p_name=>'INSIDE'
,p_display_name=>'Inside'
,p_display_sequence=>50
,p_region_template_id=>wwv_flow_api.id(12495587659835880238)
,p_css_classes=>'js-popup-pos-inside'
,p_group_id=>wwv_flow_api.id(88250220448008763)
,p_template_types=>'REGION'
,p_help_text=>'Positions the callout inside of the parent. This is useful when the parent is sufficiently large, such as a report or large region.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495584857677880235)
,p_theme_id=>42
,p_name=>'BELOW'
,p_display_name=>'Below'
,p_display_sequence=>40
,p_region_template_id=>wwv_flow_api.id(12495587659835880238)
,p_css_classes=>'js-popup-pos-below'
,p_group_id=>wwv_flow_api.id(88250220448008763)
,p_template_types=>'REGION'
,p_help_text=>'Positions the callout below or typically to the bottom of the parent.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495585053174880235)
,p_theme_id=>42
,p_name=>'BEFORE'
,p_display_name=>'Before'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495587659835880238)
,p_css_classes=>'js-popup-pos-before'
,p_group_id=>wwv_flow_api.id(88250220448008763)
,p_template_types=>'REGION'
,p_help_text=>'Positions the callout before or typically to the left of the parent.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495585269207880237)
,p_theme_id=>42
,p_name=>'AFTER'
,p_display_name=>'After'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495587659835880238)
,p_css_classes=>'js-popup-pos-after'
,p_group_id=>wwv_flow_api.id(88250220448008763)
,p_template_types=>'REGION'
,p_help_text=>'Positions the callout after or typically to the right of the parent.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495585485182880237)
,p_theme_id=>42
,p_name=>'ABOVE'
,p_display_name=>'Above'
,p_display_sequence=>30
,p_region_template_id=>wwv_flow_api.id(12495587659835880238)
,p_css_classes=>'js-popup-pos-above'
,p_group_id=>wwv_flow_api.id(88250220448008763)
,p_template_types=>'REGION'
,p_help_text=>'Positions the callout above or typically on top of the parent.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495585866516880237)
,p_theme_id=>42
,p_name=>'REMOVE_PAGE_OVERLAY'
,p_display_name=>'Remove Page Overlay'
,p_display_sequence=>30
,p_region_template_id=>wwv_flow_api.id(12495587659835880238)
,p_css_classes=>'js-popup-noOverlay'
,p_template_types=>'REGION'
,p_help_text=>'This option will display the inline dialog without an overlay on the background.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495586067630880237)
,p_theme_id=>42
,p_name=>'DISPLAY_POPUP_CALLOUT'
,p_display_name=>'Display Popup Callout'
,p_display_sequence=>40
,p_region_template_id=>wwv_flow_api.id(12495587659835880238)
,p_css_classes=>'js-popup-callout'
,p_template_types=>'REGION'
,p_help_text=>'Use this option to add display a callout for the popup. Note that callout will only be displayed if the data-parent-element custom attribute is defined.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495586216074880237)
,p_theme_id=>42
,p_name=>'LARGE_720X480'
,p_display_name=>'Large (720x480)'
,p_display_sequence=>30
,p_region_template_id=>wwv_flow_api.id(12495587659835880238)
,p_css_classes=>'js-dialog-size720x480'
,p_group_id=>wwv_flow_api.id(88251833169008763)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495586421524880237)
,p_theme_id=>42
,p_name=>'MEDIUM_600X400'
,p_display_name=>'Medium (600x400)'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495587659835880238)
,p_css_classes=>'js-dialog-size600x400'
,p_group_id=>wwv_flow_api.id(88251833169008763)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495586693891880237)
,p_theme_id=>42
,p_name=>'SMALL_480X320'
,p_display_name=>'Small (480x320)'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495587659835880238)
,p_css_classes=>'js-dialog-size480x320'
,p_group_id=>wwv_flow_api.id(88251833169008763)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495586831251880238)
,p_theme_id=>42
,p_name=>'NONE'
,p_display_name=>'None'
,p_display_sequence=>1
,p_region_template_id=>wwv_flow_api.id(12495587659835880238)
,p_css_classes=>'js-dialog-nosize'
,p_group_id=>wwv_flow_api.id(88251833169008763)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495587038684880238)
,p_theme_id=>42
,p_name=>'AUTO_HEIGHT_INLINE_DIALOG'
,p_display_name=>'Auto Height'
,p_display_sequence=>1
,p_region_template_id=>wwv_flow_api.id(12495587659835880238)
,p_css_classes=>'js-dialog-autoheight'
,p_template_types=>'REGION'
,p_help_text=>'This option will set the height of the dialog to fit its contents.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495587746569880238)
,p_theme_id=>42
,p_name=>'REMOVE_BODY_PADDING'
,p_display_name=>'Remove Body Padding'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495589722092880240)
,p_css_classes=>'t-HeroRegion--noPadding'
,p_template_types=>'REGION'
,p_help_text=>'Removes the padding around the hero region.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495587930547880238)
,p_theme_id=>42
,p_name=>'ICONS_SQUARE'
,p_display_name=>'Square'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495589722092880240)
,p_css_classes=>'t-HeroRegion--iconsSquare'
,p_group_id=>wwv_flow_api.id(88253411568008764)
,p_template_types=>'REGION'
,p_help_text=>'The icons are displayed within a square.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495588149653880238)
,p_theme_id=>42
,p_name=>'ICONS_CIRCULAR'
,p_display_name=>'Circle'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495589722092880240)
,p_css_classes=>'t-HeroRegion--iconsCircle'
,p_group_id=>wwv_flow_api.id(88253411568008764)
,p_template_types=>'REGION'
,p_help_text=>'The icons are displayed within a circle.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495588544046880238)
,p_theme_id=>42
,p_name=>'DISPLAY_ICON_NO'
,p_display_name=>'No'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495589722092880240)
,p_css_classes=>'t-HeroRegion--hideIcon'
,p_group_id=>wwv_flow_api.id(88252152467008763)
,p_template_types=>'REGION'
,p_help_text=>'Hide the Hero Region icon.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495588912806880238)
,p_theme_id=>42
,p_name=>'STACKED_FEATURED'
,p_display_name=>'Stacked Featured'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495589722092880240)
,p_css_classes=>'t-HeroRegion--featured t-HeroRegion--centered'
,p_group_id=>wwv_flow_api.id(88258647145008765)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495589129431880238)
,p_theme_id=>42
,p_name=>'FEATURED'
,p_display_name=>'Featured'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495589722092880240)
,p_css_classes=>'t-HeroRegion--featured'
,p_group_id=>wwv_flow_api.id(88258647145008765)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495589837707880240)
,p_theme_id=>42
,p_name=>'STACKED'
,p_display_name=>'Stack Region'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495596329535880246)
,p_css_classes=>'t-Region--stacked'
,p_group_id=>wwv_flow_api.id(88258647145008765)
,p_template_types=>'REGION'
,p_help_text=>'Removes side borders and shadows, and can be useful for accordions and regions that need to be grouped together vertically.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495590016112880242)
,p_theme_id=>42
,p_name=>'SHOW_REGION_ICON'
,p_display_name=>'Show Region Icon'
,p_display_sequence=>50
,p_region_template_id=>wwv_flow_api.id(12495596329535880246)
,p_css_classes=>'t-Region--showIcon'
,p_template_types=>'REGION'
,p_help_text=>'Displays the region icon in the region header beside the region title'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495590250587880242)
,p_theme_id=>42
,p_name=>'SHOW_NEXT_AND_PREVIOUS_BUTTONS'
,p_display_name=>'Show Next and Previous Buttons'
,p_display_sequence=>30
,p_region_template_id=>wwv_flow_api.id(12495596329535880246)
,p_css_classes=>'t-Region--showCarouselControls'
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495590497429880242)
,p_theme_id=>42
,p_name=>'SCROLLBODY'
,p_display_name=>'Scroll'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495596329535880246)
,p_css_classes=>'t-Region--scrollBody'
,p_group_id=>wwv_flow_api.id(88248951551008763)
,p_template_types=>'REGION'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495590648586880242)
,p_theme_id=>42
,p_name=>'HIDDENHEADERNOAT'
,p_display_name=>'Hidden'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495596329535880246)
,p_css_classes=>'t-Region--removeHeader'
,p_group_id=>wwv_flow_api.id(88252596160008764)
,p_template_types=>'REGION'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495590877434880242)
,p_theme_id=>42
,p_name=>'NOBODYPADDING'
,p_display_name=>'Remove Body Padding'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495596329535880246)
,p_css_classes=>'t-Region--noPadding'
,p_template_types=>'REGION'
,p_help_text=>'Removes padding from region body.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495591043524880243)
,p_theme_id=>42
,p_name=>'NOBORDER'
,p_display_name=>'Remove Borders'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495596329535880246)
,p_css_classes=>'t-Region--noBorder'
,p_group_id=>wwv_flow_api.id(88258647145008765)
,p_template_types=>'REGION'
,p_help_text=>'Removes borders from the region.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495591219314880243)
,p_theme_id=>42
,p_name=>'HIDEREGIONHEADER'
,p_display_name=>'Hidden but accessible'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495596329535880246)
,p_css_classes=>'t-Region--hideHeader'
,p_group_id=>wwv_flow_api.id(88252596160008764)
,p_template_types=>'REGION'
,p_help_text=>'This option will hide the region header.  Note that the region title will still be audible for Screen Readers. Buttons placed in the region header will be hidden and inaccessible.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495591631366880243)
,p_theme_id=>42
,p_name=>'HIDEOVERFLOW'
,p_display_name=>'Hide'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495596329535880246)
,p_css_classes=>'t-Region--hiddenOverflow'
,p_group_id=>wwv_flow_api.id(88248951551008763)
,p_template_types=>'REGION'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495591890082880243)
,p_theme_id=>42
,p_name=>'SPIN'
,p_display_name=>'Spin'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495596329535880246)
,p_css_classes=>'t-Region--carouselSpin'
,p_group_id=>wwv_flow_api.id(88248215024008762)
,p_template_types=>'REGION'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495592067407880243)
,p_theme_id=>42
,p_name=>'SLIDE'
,p_display_name=>'Slide'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495596329535880246)
,p_css_classes=>'t-Region--carouselSlide'
,p_group_id=>wwv_flow_api.id(88248215024008762)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495592443791880243)
,p_theme_id=>42
,p_name=>'ACCENT_5'
,p_display_name=>'Accent 5'
,p_display_sequence=>50
,p_region_template_id=>wwv_flow_api.id(12495596329535880246)
,p_css_classes=>'t-Region--accent5'
,p_group_id=>wwv_flow_api.id(88246153834008762)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495592668696880243)
,p_theme_id=>42
,p_name=>'ACCENT_4'
,p_display_name=>'Accent 4'
,p_display_sequence=>40
,p_region_template_id=>wwv_flow_api.id(12495596329535880246)
,p_css_classes=>'t-Region--accent4'
,p_group_id=>wwv_flow_api.id(88246153834008762)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495592834823880243)
,p_theme_id=>42
,p_name=>'ACCENT_3'
,p_display_name=>'Accent 3'
,p_display_sequence=>30
,p_region_template_id=>wwv_flow_api.id(12495596329535880246)
,p_css_classes=>'t-Region--accent3'
,p_group_id=>wwv_flow_api.id(88246153834008762)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495593039880880243)
,p_theme_id=>42
,p_name=>'ACCENT_2'
,p_display_name=>'Accent 2'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495596329535880246)
,p_css_classes=>'t-Region--accent2'
,p_group_id=>wwv_flow_api.id(88246153834008762)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495593267359880243)
,p_theme_id=>42
,p_name=>'ACCENT_1'
,p_display_name=>'Accent 1'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495596329535880246)
,p_css_classes=>'t-Region--accent1'
,p_group_id=>wwv_flow_api.id(88246153834008762)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495593431587880243)
,p_theme_id=>42
,p_name=>'REMEMBER_CAROUSEL_SLIDE'
,p_display_name=>'Remember Carousel Slide'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495596329535880246)
,p_css_classes=>'js-useLocalStorage'
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495593613282880243)
,p_theme_id=>42
,p_name=>'SHOW_MAXIMIZE_BUTTON'
,p_display_name=>'Show Maximize Button'
,p_display_sequence=>40
,p_region_template_id=>wwv_flow_api.id(12495596329535880246)
,p_css_classes=>'js-showMaximizeButton'
,p_template_types=>'REGION'
,p_help_text=>'Displays a button in the Region Header to maximize the region. Clicking this button will toggle the maximize state and stretch the region to fill the screen.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495593829090880243)
,p_theme_id=>42
,p_name=>'5_SECONDS'
,p_display_name=>'5 Seconds'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495596329535880246)
,p_css_classes=>'js-cycle5s'
,p_group_id=>wwv_flow_api.id(88259757770008765)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495594095497880243)
,p_theme_id=>42
,p_name=>'20_SECONDS'
,p_display_name=>'20 Seconds'
,p_display_sequence=>40
,p_region_template_id=>wwv_flow_api.id(12495596329535880246)
,p_css_classes=>'js-cycle20s'
,p_group_id=>wwv_flow_api.id(88259757770008765)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495594285476880243)
,p_theme_id=>42
,p_name=>'15_SECONDS'
,p_display_name=>'15 Seconds'
,p_display_sequence=>30
,p_region_template_id=>wwv_flow_api.id(12495596329535880246)
,p_css_classes=>'js-cycle15s'
,p_group_id=>wwv_flow_api.id(88259757770008765)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495594466484880245)
,p_theme_id=>42
,p_name=>'10_SECONDS'
,p_display_name=>'10 Seconds'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495596329535880246)
,p_css_classes=>'js-cycle10s'
,p_group_id=>wwv_flow_api.id(88259757770008765)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495594805504880245)
,p_theme_id=>42
,p_name=>'640PX'
,p_display_name=>'640px'
,p_display_sequence=>40
,p_region_template_id=>wwv_flow_api.id(12495596329535880246)
,p_css_classes=>'i-h640'
,p_group_id=>wwv_flow_api.id(88248561281008762)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495595094074880245)
,p_theme_id=>42
,p_name=>'480PX'
,p_display_name=>'480px'
,p_display_sequence=>30
,p_region_template_id=>wwv_flow_api.id(12495596329535880246)
,p_css_classes=>'i-h480'
,p_group_id=>wwv_flow_api.id(88248561281008762)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495595287841880245)
,p_theme_id=>42
,p_name=>'320PX'
,p_display_name=>'320px'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495596329535880246)
,p_css_classes=>'i-h320'
,p_group_id=>wwv_flow_api.id(88248561281008762)
,p_template_types=>'REGION'
,p_help_text=>'Sets region body height to 320px.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495595452102880245)
,p_theme_id=>42
,p_name=>'240PX'
,p_display_name=>'240px'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495596329535880246)
,p_css_classes=>'i-h240'
,p_group_id=>wwv_flow_api.id(88248561281008762)
,p_template_types=>'REGION'
,p_help_text=>'Sets region body height to 240px.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495596416603880246)
,p_theme_id=>42
,p_name=>'SHOW_REGION_ICON'
,p_display_name=>'Show Region Icon'
,p_display_sequence=>30
,p_region_template_id=>wwv_flow_api.id(12495598315850880248)
,p_css_classes=>'t-ContentBlock--showIcon'
,p_template_types=>'REGION'
,p_help_text=>'Displays the region icon in the region header beside the region title'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495596673454880246)
,p_theme_id=>42
,p_name=>'SHADOW_BACKGROUND'
,p_display_name=>'Shadow Background'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495598315850880248)
,p_css_classes=>'t-ContentBlock--shadowBG'
,p_group_id=>wwv_flow_api.id(88249802752008763)
,p_template_types=>'REGION'
,p_help_text=>'Gives the region body a slightly darker background.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495596860070880246)
,p_theme_id=>42
,p_name=>'ADD_BODY_PADDING'
,p_display_name=>'Add Body Padding'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495598315850880248)
,p_css_classes=>'t-ContentBlock--padded'
,p_template_types=>'REGION'
,p_help_text=>'Adds padding to the region''s body container.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495597072713880246)
,p_theme_id=>42
,p_name=>'LIGHT_BACKGROUND'
,p_display_name=>'Light Background'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495598315850880248)
,p_css_classes=>'t-ContentBlock--lightBG'
,p_group_id=>wwv_flow_api.id(88249802752008763)
,p_template_types=>'REGION'
,p_help_text=>'Gives the region body a slightly lighter background.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495597488495880246)
,p_theme_id=>42
,p_name=>'CONTENT_TITLE_H3'
,p_display_name=>'Heading Level 3'
,p_display_sequence=>30
,p_region_template_id=>wwv_flow_api.id(12495598315850880248)
,p_css_classes=>'t-ContentBlock--h3'
,p_group_id=>wwv_flow_api.id(88257822764008765)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495597661960880246)
,p_theme_id=>42
,p_name=>'CONTENT_TITLE_H2'
,p_display_name=>'Heading Level 2'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495598315850880248)
,p_css_classes=>'t-ContentBlock--h2'
,p_group_id=>wwv_flow_api.id(88257822764008765)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495597823652880248)
,p_theme_id=>42
,p_name=>'CONTENT_TITLE_H1'
,p_display_name=>'Heading Level 1'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495598315850880248)
,p_css_classes=>'t-ContentBlock--h1'
,p_group_id=>wwv_flow_api.id(88257822764008765)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495598458885880248)
,p_theme_id=>42
,p_name=>'STACKED'
,p_display_name=>'Stack Region'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495604368136880259)
,p_css_classes=>'t-Region--stacked'
,p_group_id=>wwv_flow_api.id(88258647145008765)
,p_template_types=>'REGION'
,p_help_text=>'Removes side borders and shadows, and can be useful for accordions and regions that need to be grouped together vertically.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495598655818880248)
,p_theme_id=>42
,p_name=>'SCROLLBODY'
,p_display_name=>'Scroll - Default'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495604368136880259)
,p_css_classes=>'t-Region--scrollBody'
,p_group_id=>wwv_flow_api.id(88248951551008763)
,p_template_types=>'REGION'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495598807938880251)
,p_theme_id=>42
,p_name=>'REMOVE_UI_DECORATION'
,p_display_name=>'Remove UI Decoration'
,p_display_sequence=>30
,p_region_template_id=>wwv_flow_api.id(12495604368136880259)
,p_css_classes=>'t-Region--noUI'
,p_group_id=>wwv_flow_api.id(88258647145008765)
,p_template_types=>'REGION'
,p_help_text=>'Removes UI decoration (borders, backgrounds, shadows, etc) from the region.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495599019151880251)
,p_theme_id=>42
,p_name=>'NOBODYPADDING'
,p_display_name=>'Remove Body Padding'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495604368136880259)
,p_css_classes=>'t-Region--noPadding'
,p_template_types=>'REGION'
,p_help_text=>'Removes padding from region body.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495599221282880256)
,p_theme_id=>42
,p_name=>'NOBORDER'
,p_display_name=>'Remove Borders'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495604368136880259)
,p_css_classes=>'t-Region--noBorder'
,p_group_id=>wwv_flow_api.id(88258647145008765)
,p_template_types=>'REGION'
,p_help_text=>'Removes borders from the region.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495599460439880256)
,p_theme_id=>42
,p_name=>'ICONS_PLUS_OR_MINUS'
,p_display_name=>'Plus or Minus'
,p_display_sequence=>1
,p_region_template_id=>wwv_flow_api.id(12495604368136880259)
,p_css_classes=>'t-Region--hideShowIconsMath'
,p_group_id=>wwv_flow_api.id(88250587824008763)
,p_template_types=>'REGION'
,p_help_text=>'Use the plus and minus icons for the expand and collapse button.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495599896207880256)
,p_theme_id=>42
,p_name=>'HIDEOVERFLOW'
,p_display_name=>'Hide'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495604368136880259)
,p_css_classes=>'t-Region--hiddenOverflow'
,p_group_id=>wwv_flow_api.id(88248951551008763)
,p_template_types=>'REGION'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495600257183880256)
,p_theme_id=>42
,p_name=>'CONRTOLS_POSITION_END'
,p_display_name=>'End'
,p_display_sequence=>1
,p_region_template_id=>wwv_flow_api.id(12495604368136880259)
,p_css_classes=>'t-Region--controlsPosEnd'
,p_group_id=>wwv_flow_api.id(88251039421008763)
,p_template_types=>'REGION'
,p_help_text=>'Position the expand / collapse button to the end of the region header.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495600653844880256)
,p_theme_id=>42
,p_name=>'ACCENT_5'
,p_display_name=>'Accent 5'
,p_display_sequence=>50
,p_region_template_id=>wwv_flow_api.id(12495604368136880259)
,p_css_classes=>'t-Region--accent5'
,p_group_id=>wwv_flow_api.id(88246153834008762)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495600845620880256)
,p_theme_id=>42
,p_name=>'ACCENT_4'
,p_display_name=>'Accent 4'
,p_display_sequence=>40
,p_region_template_id=>wwv_flow_api.id(12495604368136880259)
,p_css_classes=>'t-Region--accent4'
,p_group_id=>wwv_flow_api.id(88246153834008762)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495601099083880256)
,p_theme_id=>42
,p_name=>'ACCENT_3'
,p_display_name=>'Accent 3'
,p_display_sequence=>30
,p_region_template_id=>wwv_flow_api.id(12495604368136880259)
,p_css_classes=>'t-Region--accent3'
,p_group_id=>wwv_flow_api.id(88246153834008762)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495601297358880256)
,p_theme_id=>42
,p_name=>'ACCENT_2'
,p_display_name=>'Accent 2'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495604368136880259)
,p_css_classes=>'t-Region--accent2'
,p_group_id=>wwv_flow_api.id(88246153834008762)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495601469175880257)
,p_theme_id=>42
,p_name=>'ACCENT_1'
,p_display_name=>'Accent 1'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495604368136880259)
,p_css_classes=>'t-Region--accent1'
,p_group_id=>wwv_flow_api.id(88246153834008762)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495601865143880257)
,p_theme_id=>42
,p_name=>'REMEMBER_COLLAPSIBLE_STATE'
,p_display_name=>'Remember Collapsible State'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495604368136880259)
,p_css_classes=>'js-useLocalStorage'
,p_template_types=>'REGION'
,p_help_text=>'This option saves the current state of the collapsible region for the duration of the session.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495602012675880257)
,p_theme_id=>42
,p_name=>'EXPANDED'
,p_display_name=>'Expanded'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495604368136880259)
,p_css_classes=>'is-expanded'
,p_group_id=>wwv_flow_api.id(88251409030008763)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495602261238880257)
,p_theme_id=>42
,p_name=>'COLLAPSED'
,p_display_name=>'Collapsed'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495604368136880259)
,p_css_classes=>'is-collapsed'
,p_group_id=>wwv_flow_api.id(88251409030008763)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495602646850880257)
,p_theme_id=>42
,p_name=>'640PX'
,p_display_name=>'640px'
,p_display_sequence=>40
,p_region_template_id=>wwv_flow_api.id(12495604368136880259)
,p_css_classes=>'i-h640'
,p_group_id=>wwv_flow_api.id(88248561281008762)
,p_template_types=>'REGION'
,p_help_text=>'Sets body height to 640px.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495602889079880257)
,p_theme_id=>42
,p_name=>'480PX'
,p_display_name=>'480px'
,p_display_sequence=>30
,p_region_template_id=>wwv_flow_api.id(12495604368136880259)
,p_css_classes=>'i-h480'
,p_group_id=>wwv_flow_api.id(88248561281008762)
,p_template_types=>'REGION'
,p_help_text=>'Sets body height to 480px.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495603000093880257)
,p_theme_id=>42
,p_name=>'320PX'
,p_display_name=>'320px'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495604368136880259)
,p_css_classes=>'i-h320'
,p_group_id=>wwv_flow_api.id(88248561281008762)
,p_template_types=>'REGION'
,p_help_text=>'Sets region body height to 320px.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495603220585880257)
,p_theme_id=>42
,p_name=>'240PX'
,p_display_name=>'240px'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495604368136880259)
,p_css_classes=>'i-h240'
,p_group_id=>wwv_flow_api.id(88248561281008762)
,p_template_types=>'REGION'
,p_help_text=>'Sets region body height to 240px.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495604444412880259)
,p_theme_id=>42
,p_name=>'STICK_TO_BOTTOM'
,p_display_name=>'Stick to Bottom for Mobile'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495606500823880260)
,p_css_classes=>'t-ButtonRegion--stickToBottom'
,p_template_types=>'REGION'
,p_help_text=>'This will position the button container region to the bottom of the screen for small screens.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495604689788880259)
,p_theme_id=>42
,p_name=>'SLIMPADDING'
,p_display_name=>'Slim Padding'
,p_display_sequence=>5
,p_region_template_id=>wwv_flow_api.id(12495606500823880260)
,p_css_classes=>'t-ButtonRegion--slimPadding'
,p_group_id=>wwv_flow_api.id(88249397251008763)
,p_template_types=>'REGION'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495604824313880259)
,p_theme_id=>42
,p_name=>'REMOVEUIDECORATION'
,p_display_name=>'Remove UI Decoration'
,p_display_sequence=>4
,p_region_template_id=>wwv_flow_api.id(12495606500823880260)
,p_css_classes=>'t-ButtonRegion--noUI'
,p_group_id=>wwv_flow_api.id(88258647145008765)
,p_template_types=>'REGION'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495605059156880259)
,p_theme_id=>42
,p_name=>'NOPADDING'
,p_display_name=>'No Padding'
,p_display_sequence=>3
,p_region_template_id=>wwv_flow_api.id(12495606500823880260)
,p_css_classes=>'t-ButtonRegion--noPadding'
,p_group_id=>wwv_flow_api.id(88249397251008763)
,p_template_types=>'REGION'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495605468649880260)
,p_theme_id=>42
,p_name=>'BORDERLESS'
,p_display_name=>'Borderless'
,p_display_sequence=>1
,p_region_template_id=>wwv_flow_api.id(12495606500823880260)
,p_css_classes=>'t-ButtonRegion--noBorder'
,p_group_id=>wwv_flow_api.id(88258647145008765)
,p_template_types=>'REGION'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495606658903880260)
,p_theme_id=>42
,p_name=>'REMOVE_BODY_PADDING'
,p_display_name=>'Remove Body Padding'
,p_display_sequence=>5
,p_region_template_id=>wwv_flow_api.id(12495608896288880263)
,p_css_classes=>'t-DialogRegion--noPadding'
,p_template_types=>'REGION'
,p_help_text=>'Removes the padding around the region body.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495606813623880260)
,p_theme_id=>42
,p_name=>'RESIZABLE'
,p_display_name=>'Resizable'
,p_display_sequence=>30
,p_region_template_id=>wwv_flow_api.id(12495608896288880263)
,p_css_classes=>'js-resizable'
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495607098214880260)
,p_theme_id=>42
,p_name=>'MODAL'
,p_display_name=>'Modal'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495608896288880263)
,p_css_classes=>'js-modal'
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495607234997880262)
,p_theme_id=>42
,p_name=>'DRAGGABLE'
,p_display_name=>'Draggable'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495608896288880263)
,p_css_classes=>'js-draggable'
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495607450254880262)
,p_theme_id=>42
,p_name=>'LARGE_720X480'
,p_display_name=>'Large (720x480)'
,p_display_sequence=>30
,p_region_template_id=>wwv_flow_api.id(12495608896288880263)
,p_css_classes=>'js-dialog-size720x480'
,p_group_id=>wwv_flow_api.id(88251833169008763)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495607646016880262)
,p_theme_id=>42
,p_name=>'MEDIUM_600X400'
,p_display_name=>'Medium (600x400)'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495608896288880263)
,p_css_classes=>'js-dialog-size600x400'
,p_group_id=>wwv_flow_api.id(88251833169008763)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495607815474880262)
,p_theme_id=>42
,p_name=>'SMALL_480X320'
,p_display_name=>'Small (480x320)'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495608896288880263)
,p_css_classes=>'js-dialog-size480x320'
,p_group_id=>wwv_flow_api.id(88251833169008763)
,p_template_types=>'REGION'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495608262473880262)
,p_theme_id=>42
,p_name=>'AUTO_HEIGHT_INLINE_DIALOG'
,p_display_name=>'Auto Height'
,p_display_sequence=>1
,p_region_template_id=>wwv_flow_api.id(12495608896288880263)
,p_css_classes=>'js-dialog-autoheight'
,p_template_types=>'REGION'
,p_help_text=>'This option will set the height of the dialog to fit its contents.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495609999660880263)
,p_theme_id=>42
,p_name=>'WIZARD'
,p_display_name=>'Wizard'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495613507239880288)
,p_css_classes=>'t-Alert--wizard'
,p_group_id=>wwv_flow_api.id(88246564724008762)
,p_template_types=>'REGION'
,p_help_text=>'Show the alert in a wizard style region.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495610108226880268)
,p_theme_id=>42
,p_name=>'WARNING'
,p_display_name=>'Warning'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495613507239880288)
,p_css_classes=>'t-Alert--warning'
,p_group_id=>wwv_flow_api.id(88247788535008762)
,p_template_types=>'REGION'
,p_help_text=>'Show a warning alert.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495610303047880268)
,p_theme_id=>42
,p_name=>'SUCCESS'
,p_display_name=>'Success'
,p_display_sequence=>40
,p_region_template_id=>wwv_flow_api.id(12495613507239880288)
,p_css_classes=>'t-Alert--success'
,p_group_id=>wwv_flow_api.id(88247788535008762)
,p_template_types=>'REGION'
,p_help_text=>'Show success alert.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495610521728880268)
,p_theme_id=>42
,p_name=>'HIDDENHEADERNOAT'
,p_display_name=>'Hidden'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495613507239880288)
,p_css_classes=>'t-Alert--removeHeading'
,p_group_id=>wwv_flow_api.id(88247362124008762)
,p_template_types=>'REGION'
,p_help_text=>'Hides the Alert Title from being displayed.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495610721345880268)
,p_theme_id=>42
,p_name=>'HIDE_ICONS'
,p_display_name=>'Hide Icons'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495613507239880288)
,p_css_classes=>'t-Alert--noIcon'
,p_group_id=>wwv_flow_api.id(88247035260008762)
,p_template_types=>'REGION'
,p_help_text=>'Hides alert icons'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495610967418880268)
,p_theme_id=>42
,p_name=>'INFORMATION'
,p_display_name=>'Information'
,p_display_sequence=>30
,p_region_template_id=>wwv_flow_api.id(12495613507239880288)
,p_css_classes=>'t-Alert--info'
,p_group_id=>wwv_flow_api.id(88247788535008762)
,p_template_types=>'REGION'
,p_help_text=>'Show informational alert.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495611165937880268)
,p_theme_id=>42
,p_name=>'HORIZONTAL'
,p_display_name=>'Horizontal'
,p_display_sequence=>10
,p_region_template_id=>wwv_flow_api.id(12495613507239880288)
,p_css_classes=>'t-Alert--horizontal'
,p_group_id=>wwv_flow_api.id(88246564724008762)
,p_template_types=>'REGION'
,p_help_text=>'Show horizontal alert with buttons to the right.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495611577386880271)
,p_theme_id=>42
,p_name=>'USEDEFAULTICONS'
,p_display_name=>'Show Default Icons'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495613507239880288)
,p_css_classes=>'t-Alert--defaultIcons'
,p_group_id=>wwv_flow_api.id(88247035260008762)
,p_template_types=>'REGION'
,p_help_text=>'Uses default icons for alert types.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495611707140880271)
,p_theme_id=>42
,p_name=>'DANGER'
,p_display_name=>'Danger'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495613507239880288)
,p_css_classes=>'t-Alert--danger'
,p_group_id=>wwv_flow_api.id(88247788535008762)
,p_template_types=>'REGION'
,p_help_text=>'Show an error or danger alert.'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495612123859880271)
,p_theme_id=>42
,p_name=>'SHOW_CUSTOM_ICONS'
,p_display_name=>'Show Custom Icons'
,p_display_sequence=>30
,p_region_template_id=>wwv_flow_api.id(12495613507239880288)
,p_css_classes=>'t-Alert--customIcons'
,p_group_id=>wwv_flow_api.id(88247035260008762)
,p_template_types=>'REGION'
,p_help_text=>'Set custom icons by modifying the Alert Region''s Icon CSS Classes property.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495612589926880273)
,p_theme_id=>42
,p_name=>'COLOREDBACKGROUND'
,p_display_name=>'Highlight Background'
,p_display_sequence=>1
,p_region_template_id=>wwv_flow_api.id(12495613507239880288)
,p_css_classes=>'t-Alert--colorBG'
,p_template_types=>'REGION'
,p_help_text=>'Set alert background color to that of the alert type (warning, success, etc.)'
,p_is_advanced=>'N'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495612726392880274)
,p_theme_id=>42
,p_name=>'HIDDENHEADER'
,p_display_name=>'Hidden but Accessible'
,p_display_sequence=>20
,p_region_template_id=>wwv_flow_api.id(12495613507239880288)
,p_css_classes=>'t-Alert--accessibleHeading'
,p_group_id=>wwv_flow_api.id(88247362124008762)
,p_template_types=>'REGION'
,p_help_text=>'Visually hides the alert title, but assistive technologies can still read it.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495613643163880290)
,p_theme_id=>42
,p_name=>'STICKY_HEADER_ON_MOBILE'
,p_display_name=>'Sticky Header on Mobile'
,p_display_sequence=>100
,p_page_template_id=>wwv_flow_api.id(12495616037696880296)
,p_css_classes=>'js-pageStickyMobileHeader'
,p_template_types=>'PAGE'
,p_help_text=>'This will position the contents of the Breadcrumb Bar region position so it sticks to the top of the screen for small screens.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495616119590880296)
,p_theme_id=>42
,p_name=>'STICKY_HEADER_ON_MOBILE'
,p_display_name=>'Sticky Header on Mobile'
,p_display_sequence=>100
,p_page_template_id=>wwv_flow_api.id(12495618547053880299)
,p_css_classes=>'js-pageStickyMobileHeader'
,p_template_types=>'PAGE'
,p_help_text=>'This will position the contents of the Breadcrumb Bar region position so it sticks to the top of the screen for small screens.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495618656086880299)
,p_theme_id=>42
,p_name=>'STRETCH_TO_FIT_WINDOW'
,p_display_name=>'Stretch to Fit Window'
,p_display_sequence=>10
,p_page_template_id=>wwv_flow_api.id(12495620021366880299)
,p_css_classes=>'ui-dialog--stretch'
,p_template_types=>'PAGE'
,p_help_text=>'Stretch the dialog to fit the browser window.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495618865060880299)
,p_theme_id=>42
,p_name=>'REMOVE_BODY_PADDING'
,p_display_name=>'Remove Body Padding'
,p_display_sequence=>20
,p_page_template_id=>wwv_flow_api.id(12495620021366880299)
,p_css_classes=>'t-Dialog--noPadding'
,p_template_types=>'PAGE'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495620104205880299)
,p_theme_id=>42
,p_name=>'STICKY_HEADER_ON_MOBILE'
,p_display_name=>'Sticky Header on Mobile'
,p_display_sequence=>100
,p_page_template_id=>wwv_flow_api.id(12495622898900880302)
,p_css_classes=>'js-pageStickyMobileHeader'
,p_template_types=>'PAGE'
,p_help_text=>'This will position the contents of the Breadcrumb Bar region position so it sticks to the top of the screen for small screens.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495622952146880302)
,p_theme_id=>42
,p_name=>'STRETCH_TO_FIT_WINDOW'
,p_display_name=>'Stretch to Fit Window'
,p_display_sequence=>1
,p_page_template_id=>wwv_flow_api.id(12495624331342880306)
,p_css_classes=>'ui-dialog--stretch'
,p_template_types=>'PAGE'
,p_help_text=>'Stretch the dialog to fit the browser window.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495623136658880304)
,p_theme_id=>42
,p_name=>'REMOVE_BODY_PADDING'
,p_display_name=>'Remove Body Padding'
,p_display_sequence=>20
,p_page_template_id=>wwv_flow_api.id(12495624331342880306)
,p_css_classes=>'t-Dialog--noPadding'
,p_template_types=>'PAGE'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495624497392880306)
,p_theme_id=>42
,p_name=>'STICKY_HEADER_ON_MOBILE'
,p_display_name=>'Sticky Header on Mobile'
,p_display_sequence=>100
,p_page_template_id=>wwv_flow_api.id(12495627437383880309)
,p_css_classes=>'js-pageStickyMobileHeader'
,p_template_types=>'PAGE'
,p_help_text=>'This will position the contents of the Breadcrumb Bar region position so it sticks to the top of the screen for small screens.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495627533213880309)
,p_theme_id=>42
,p_name=>'PAGE_LAYOUT_SPLIT'
,p_display_name=>'Split'
,p_display_sequence=>1
,p_page_template_id=>wwv_flow_api.id(12495629732925880320)
,p_css_classes=>'t-LoginPage--split'
,p_group_id=>wwv_flow_api.id(88245770492008762)
,p_template_types=>'PAGE'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495627901544880309)
,p_theme_id=>42
,p_name=>'PAGE_BACKGROUND_3'
,p_display_name=>'Background 3'
,p_display_sequence=>30
,p_page_template_id=>wwv_flow_api.id(12495629732925880320)
,p_css_classes=>'t-LoginPage--bg3'
,p_group_id=>wwv_flow_api.id(88245349128008762)
,p_template_types=>'PAGE'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495628133484880309)
,p_theme_id=>42
,p_name=>'PAGE_BACKGROUND_2'
,p_display_name=>'Background 2'
,p_display_sequence=>20
,p_page_template_id=>wwv_flow_api.id(12495629732925880320)
,p_css_classes=>'t-LoginPage--bg2'
,p_group_id=>wwv_flow_api.id(88245349128008762)
,p_template_types=>'PAGE'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495628369896880310)
,p_theme_id=>42
,p_name=>'PAGE_BACKGROUND_1'
,p_display_name=>'Background 1'
,p_display_sequence=>10
,p_page_template_id=>wwv_flow_api.id(12495629732925880320)
,p_css_classes=>'t-LoginPage--bg1'
,p_group_id=>wwv_flow_api.id(88245349128008762)
,p_template_types=>'PAGE'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495629830445880320)
,p_theme_id=>42
,p_name=>'STICKY_HEADER_ON_MOBILE'
,p_display_name=>'Sticky Header on Mobile'
,p_display_sequence=>100
,p_page_template_id=>wwv_flow_api.id(12495632827206880321)
,p_css_classes=>'js-pageStickyMobileHeader'
,p_template_types=>'PAGE'
,p_help_text=>'This will position the contents of the Breadcrumb Bar region position so it sticks to the top of the screen for small screens.'
);
wwv_flow_api.create_template_option(
 p_id=>wwv_flow_api.id(12495632933480880329)
,p_theme_id=>42
,p_name=>'STICKY_HEADER_ON_MOBILE'
,p_display_name=>'Sticky Header on Mobile'
,p_display_sequence=>100
,p_page_template_id=>wwv_flow_api.id(12495635610083880376)
,p_css_classes=>'js-pageStickyMobileHeader'
,p_template_types=>'PAGE'
,p_help_text=>'This will position the contents of the Breadcrumb Bar region position so it sticks to the top of the screen for small screens.'
);
wwv_flow_api.component_end;
end;
/

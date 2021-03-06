{*
 +--------------------------------------------------------------------+
 | CiviCRM version 4.5                                                |
 +--------------------------------------------------------------------+
 | Copyright CiviCRM LLC (c) 2004-2014                                |
 +--------------------------------------------------------------------+
 | This file is a part of CiviCRM.                                    |
 |                                                                    |
 | CiviCRM is free software; you can copy, modify, and distribute it  |
 | under the terms of the GNU Affero General Public License           |
 | Version 3, 19 November 2007 and the CiviCRM Licensing Exception.   |
 |                                                                    |
 | CiviCRM is distributed in the hope that it will be useful, but     |
 | WITHOUT ANY WARRANTY; without even the implied warranty of         |
 | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.               |
 | See the GNU Affero General Public License for more details.        |
 |                                                                    |
 | You should have received a copy of the GNU Affero General Public   |
 | License and the CiviCRM Licensing Exception along                  |
 | with this program; if not, contact CiviCRM LLC                     |
 | at info[AT]civicrm[DOT]org. If you have questions about the        |
 | GNU Affero General Public License or the licensing of CiviCRM,     |
 | see the CiviCRM license FAQ at http://civicrm.org/licensing        |
 +--------------------------------------------------------------------+
*}
<style>
  {literal}
  #api-explorer pre {
    line-height: 1.3em;
    font-size: 11px;
    margin: 0;
    border: 0 none;
  }
  pre#api-result {
    padding:1em;
    max-height: 50em;
    border: 1px solid lightgrey;
  }
  #api-params-table th:first-child,
  #api-params-table td:first-child {
    width: 35%;
  }
  #api-params-table td:first-child + td,
  #api-params-table th:first-child + th,
  #api-generated td:first-child {
    width: 9em;
  }
  #api-params {
    min-height: 1em;
  }
  #api-params .red-icon {
    margin-top: .5em;
  }
  #api-explorer label {
    display:inline;
    font-weight: bold;
  }
  #api-generated-wraper,
  #api-result {
    overflow: auto;
  }
  .select2-choice .icon {
    margin-top: .2em;
    background-image: url("{/literal}{$config->resourceBase}{literal}/i/icons/jquery-ui-2786C2.png");
  }
  .select2-default .icon {
    background-image: url("{/literal}{$config->resourceBase}{literal}/i/icons/jquery-ui-52534D.png");
    opacity: .8;
  }
  pre ol.linenums li {
    list-style-type: decimal;
    color: #CFCFCF;
  }
  pre ol.linenums li:hover {
    color: #9c9c9c;
  }
  {/literal}
</style>

<form id="api-explorer">
  <label for="api-entity">{ts}Entity{/ts}:</label>
  <select class="crm-form-select crm-select2" id="api-entity" name="entity">
    <option value="" selected="selected">{ts}Choose{/ts}...</option>
    {crmAPI entity="Entity" action="get" var="entities" version=3}
    {foreach from=$entities.values item=entity}
      <option value="{$entity}">{$entity}</option>
    {/foreach}
  </select>
  &nbsp;&nbsp;
  <label for="api-action">{ts}Action{/ts}:</label>
  <input class="crm-form-text" id="api-action" name="action" value="get">
  &nbsp;&nbsp;

  <label for="debug-checkbox" title="{ts}Display debug output with results.{/ts}">
    <input type="checkbox" class="crm-form-checkbox api-param-checkbox api-input" id="debug-checkbox" name="debug" checked="checked" value="1" >debug
  </label>
  &nbsp;|&nbsp;

  <label for="sequential-checkbox" title="{ts}Sequential is more compact format, well-suited for json and smarty.{/ts}">
    <input type="checkbox" class="crm-form-checkbox api-param-checkbox api-input" id="sequential-checkbox" name="sequential" checked="checked" value="1">sequential
  </label>

  <table id="api-params-table">
    <thead style="display: none;">
      <tr>
        <th>{ts}Name{/ts} {help id='param-name'}</th>
        <th>{ts}Operator{/ts} {help id='param-op'}</th>
        <th>{ts}Value{/ts} {help id='param-value'}</th>
      </tr>
    </thead>
    <tbody id="api-params"></tbody>
  </table>
  <div id="api-param-buttons" style="display: none;">
    <a href="#" class="crm-hover-button" id="api-params-add"><span class="icon ui-icon-plus"></span>{ts}Add Parameter{/ts}</a>
    <a href="#" class="crm-hover-button" id="api-chain-add"><span class="icon ui-icon-link"></span>{ts}Chain API Call{/ts}</a>
  </div>
  <div id="api-generated-wraper">
    <table id="api-generated" border=1>
      <caption>{ts}Code{/ts}</caption>
      <tr><td>Rest</td><td><pre class="prettyprint linenums" id="api-rest"></pre></td></tr>
      <tr><td>Smarty</td><td><pre class="prettyprint linenums" id="api-smarty" title='smarty syntax (for get actions)'></pre></td></tr>
      <tr><td>Php</td><td><pre class="prettyprint linenums" id="api-php" title='php syntax'></pre></td></tr>
      <tr><td>Javascript</td><td><pre class="prettyprint linenums" id="api-json" title='javascript syntax'></pre></td></tr>
    </table>
  </div>
  <input type="submit" value="{ts}Execute{/ts}" class="form-submit"/>
<pre id="api-result" class="linenums">
{ts}The result of api calls are displayed in this area.{/ts}
</pre>
</form>

{strip}
<script type="text/template" id="api-param-tpl">
  <tr class="api-param-row">
    <td><input style="width: 100%;" class="crm-form-text api-param-name api-input" value="<%= name %>" placeholder="{ts}Parameter{/ts}" /></td>
    <td>
      <select class="crm-form-select api-param-op">
        {foreach from=$operators item='op'}
          <option value="{$op|htmlspecialchars}">{$op|htmlspecialchars}</option>
        {/foreach}
      </select>
    </td>
    <td>
      <input style="width: 85%;" class="crm-form-text api-param-value api-input" placeholder="{ts}Value{/ts}"/>
      <a class="crm-hover-button api-param-remove" href="#"><span class="icon ui-icon-close"></span></a>
    </td>
  </tr>
</script>

<script type="text/template" id="api-chain-tpl">
  <tr class="api-chain-row">
    <td>
      <select style="width: 100%;" class="crm-form-select api-chain-entity">
        <option value=""></option>
        {foreach from=$entities.values item=entity}
          <option value="{$entity}">{$entity}</option>
        {/foreach}
      </select>
    </td>
    <td>
      <select class="crm-form-select api-chain-action">
        <option value="get">get</option>
        <option value="getsingle">getsingle</option>
        <option value="getcount">getcount</option>
        <option value="create">create</option>
        <option value="delete">delete</option>
    </select>
    </td>
    <td>
      <input style="width: 85%;" class="crm-form-text api-param-value api-input" value="{ldelim}{rdelim}" placeholder="{ts}Api Params{/ts}"/>
      <a class="crm-hover-button api-param-remove" href="#"><span class="icon ui-icon-close"></span></a>
    </td>
  </tr>
</script>
{/strip}

{**
 * plugins/generic/webFeed/templates/rss.tpl
 *
 * Copyright (c) 2014-2019 Simon Fraser University
 * Copyright (c) 2003-2019 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * RSS feed template
 *
 *}
<?xml version="1.0" encoding="{$defaultCharset|escape}"?>
<rdf:RDF
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns="http://purl.org/rss/1.0/"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:prism="http://prismstandard.org/namespaces/1.2/basic/"
	xmlns:cc="http://web.resource.org/cc/">

	<channel rdf:about="{url press=$currentPress->getPath()}">
		{* required elements *}
		<title>{$currentPress->getLocalizedName()|strip|escape:"html"}</title>
		<link>{url press=$currentPress->getPath()}</link>

		{if $currentPress->getLocalizedDescription()}
			{assign var="description" value=$currentPress->getLocalizedDescription()}
		{elseif $currentPress->getLocalizedSetting('searchDescription')}
			{assign var="description" value=$currentPress->getLocalizedSetting('searchDescription')}
		{/if}

		<description>{$description|strip|escape:"html"}</description>

		{* optional elements *}
		{assign var="publisherInstitution" value=$currentPress->getSetting('publisherInstitution')}
		{if $publisherInstitution}
			<dc:publisher>{$publisherInstitution|strip|escape:"html"}</dc:publisher>
		{/if}

		{if $currentPress->getPrimaryLocale()}
			<dc:language>{$currentPress->getPrimaryLocale()|replace:'_':'-'|strip|escape:"html"}</dc:language>
		{/if}

		<prism:publicationName>{$currentPress->getLocalizedName()|strip|escape:"html"}</prism:publicationName>

		{if $currentPress->getSetting('printIssn')}
			{assign var="ISSN" value=$currentPress->getSetting('printIssn')}
		{elseif $currentPress->getSetting('onlineIssn')}
			{assign var="ISSN" value=$currentPress->getSetting('onlineIssn')}
		{/if}

		{if $ISSN}
			<prism:issn>{$ISSN|escape}</prism:issn>
		{/if}

		{if $currentPress->getLocalizedSetting('copyrightNotice')}
			<prism:copyright>{$currentPress->getLocalizedSetting('copyrightNotice')|strip|escape:"html"}</prism:copyright>
		{/if}

		<items>
			<rdf:Seq>
				{foreach from=$publishedSubmissions item=publishedSubmission}
					<rdf:li rdf:resource="{url page="catalog" op="book" path=$publishedSubmission->getId()}"/>
				{/foreach}{* publishedSubmissions *}
			</rdf:Seq>
		</items>
	</channel>

{foreach name=publishedSubmissions from=$publishedSubmissions item=publishedSubmission}
	<item rdf:about="{url page="catalog" op="book" path=$publishedSubmission->getId()}">

		{* required elements *}
		<title>{$publishedSubmission->getLocalizedTitle()|strip|escape:"html"}</title>
		<link>{url page="catalog" op="book" path=$publishedSubmission->getId()}</link>

		{* optional elements *}
		{if $publishedSubmission->getLocalizedAbstract()}
			<description>{$publishedSubmission->getLocalizedAbstract()|strip|escape:"html"}</description>
		{/if}

		{foreach from=$publishedSubmission->getAuthors() item=author name=authorList}
			<dc:creator>{$author->getFullName(false)|strip|escape:"html"}</dc:creator>
		{/foreach}

		<dc:rights>
			{translate|escape key="submission.copyrightStatement" copyrightYear=$publishedSubmission->getCopyrightYear() copyrightHolder=$publishedSubmission->getLocalizedCopyrightHolder()}
			{$publishedSubmission->getLicenseURL()|escape}
		</dc:rights>

		<dc:date>{$publishedSubmission->getDatePublished()|date_format:"%Y-%m-%d"}</dc:date>
		<prism:publicationDate>{$publishedSubmission->getDatePublished()|date_format:"%Y-%m-%d"}</prism:publicationDate>
	</item>
{/foreach}{* publishedSubmissions *}

</rdf:RDF>


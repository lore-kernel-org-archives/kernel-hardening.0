Return-Path: <SRS0=W4y/=VW=lists.openwall.com=kernel-hardening-return-16586-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79A1BC76190
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jul 2019 19:20:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CFDAE214AE
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jul 2019 19:20:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CFDAE214AE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16586-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11617 invoked by uid 550); 25 Jul 2019 19:19:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11561 invoked from network); 25 Jul 2019 19:19:54 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: space70_377920f55ef61
X-Filterd-Recvd-Size: 2036
Message-ID: <b23889e2ba458736b3cf25e0c17a4598451e78d7.camel@perches.com>
Subject: Re: [PATCH v6] Documentation/checkpatch: Prefer stracpy over
 strcpy/strlcpy/strncpy.
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>, NitinGote <nitin.r.gote@intel.com>
Cc: corbet@lwn.net, akpm@linux-foundation.org, apw@canonical.com, 
	linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
Date: Thu, 25 Jul 2019 12:19:39 -0700
In-Reply-To: <201907251149.B7FD8631@keescook>
References: <20190725112219.6244-1-nitin.r.gote@intel.com>
	 <201907251149.B7FD8631@keescook>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2019-07-25 at 11:50 -0700, Kees Cook wrote:
> On Thu, Jul 25, 2019 at 04:52:19PM +0530, NitinGote wrote:
> > From: Nitin Gote <nitin.r.gote@intel.com>
> > 
> > Added check in checkpatch.pl to deprecate strcpy(), strlcpy() and
> > strncpy() in favor of stracpy().
> 
> stracpy() is preferred when the destination is a char array (rather than
> a string pointer), so that likely needs to be clarified.
[]
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> > @@ -605,6 +605,20 @@ foreach my $entry (keys %deprecated_apis) {
> >  }
> >  $deprecated_apis_search = "(?:${deprecated_apis_search})";
> > 
> > +our %deprecated_string_apis = (
> > +	"strcpy"		=> "stracpy",
> > +	"strlcpy"		=> "stracpy",
> > +	"strncpy"		=> "stracpy - for non-NUL-terminated uses, strncpy dest should be __nonstring",
> > +);

Maybe:

our %deprecated_string_apis = (
	"strcpy"		=> "stracpy or strscpy",
	"strlcpy"		=> "stracpy or strscpy",
	"strncpy"		=> "stracpy or strscpy - for non-NUL-terminated uses, strncpy dest should be __nonstring",
);


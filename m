Return-Path: <SRS0=LQQz=VT=lists.openwall.com=kernel-hardening-return-16529-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EB0BC7618F
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jul 2019 17:58:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ECBED21903
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jul 2019 17:58:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECBED21903
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16529-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1900 invoked by uid 550); 22 Jul 2019 17:58:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1863 invoked from network); 22 Jul 2019 17:58:30 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: leg66_2b31318223726
X-Filterd-Recvd-Size: 4181
Message-ID: <2c959c56c23d0052e5c35ecfa2f6051b17fb2798.camel@perches.com>
Subject: Re: [RFC PATCH] string.h: Add stracpy/stracpy_pad (was: Re: [PATCH]
 checkpatch: Added warnings in favor of strscpy().)
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>
Cc: Nitin Gote <nitin.r.gote@intel.com>, akpm@linux-foundation.org, 
	corbet@lwn.net, apw@canonical.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Rasmus
	Villemoes <rasmus.villemoes@prevas.dk>
Date: Mon, 22 Jul 2019 10:58:15 -0700
In-Reply-To: <b9bb5550b264d4b29b2b20f7ff8b1b40d20def6a.camel@perches.com>
References: <1562219683-15474-1-git-send-email-nitin.r.gote@intel.com>
	 <f6a4c2b601bb59179cb2e3b8f4d836a1c11379a3.camel@perches.com>
	 <d1524130f91d7cfd61bc736623409693d2895f57.camel@perches.com>
	 <201907221031.8B87A9DE@keescook>
	 <b9bb5550b264d4b29b2b20f7ff8b1b40d20def6a.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2019-07-22 at 10:43 -0700, Joe Perches wrote:
> On Mon, 2019-07-22 at 10:33 -0700, Kees Cook wrote:
> > On Thu, Jul 04, 2019 at 05:15:57PM -0700, Joe Perches wrote:
> > > On Thu, 2019-07-04 at 13:46 -0700, Joe Perches wrote:
> > > > On Thu, 2019-07-04 at 11:24 +0530, Nitin Gote wrote:
> > > > > Added warnings in checkpatch.pl script to :
> > > > > 
> > > > > 1. Deprecate strcpy() in favor of strscpy().
> > > > > 2. Deprecate strlcpy() in favor of strscpy().
> > > > > 3. Deprecate strncpy() in favor of strscpy() or strscpy_pad().
> > > > > 
> > > > > Updated strncpy() section in Documentation/process/deprecated.rst
> > > > > to cover strscpy_pad() case.
> > > 
> > > []
> > > 
> > > I sent a patch series for some strscpy/strlcpy misuses.
> > > 
> > > How about adding a macro helper to avoid the misuses like:
> > > ---
> > >  include/linux/string.h | 16 ++++++++++++++++
> > >  1 file changed, 16 insertions(+)
> > > 
> > > diff --git a/include/linux/string.h b/include/linux/string.h
> > > index 4deb11f7976b..ef01bd6f19df 100644
> > > --- a/include/linux/string.h
> > > +++ b/include/linux/string.h
> > > @@ -35,6 +35,22 @@ ssize_t strscpy(char *, const char *, size_t);
> > >  /* Wraps calls to strscpy()/memset(), no arch specific code required */
> > >  ssize_t strscpy_pad(char *dest, const char *src, size_t count);
> > >  
> > > +#define stracpy(to, from)					\
> > > +({								\
> > > +	size_t size = ARRAY_SIZE(to);				\
> > > +	BUILD_BUG_ON(!__same_type(typeof(*to), char));		\
> > > +								\
> > > +	strscpy(to, from, size);				\
> > > +})
> > > +
> > > +#define stracpy_pad(to, from)					\
> > > +({								\
> > > +	size_t size = ARRAY_SIZE(to);				\
> > > +	BUILD_BUG_ON(!__same_type(typeof(*to), char));		\
> > > +								\
> > > +	strscpy_pad(to, from, size);				\
> > > +})
> > > +
> > >  #ifndef __HAVE_ARCH_STRCAT
> > >  extern char * strcat(char *, const char *);
> > >  #endif
> > 
> > This seems like a reasonable addition, yes. I think Coccinelle might
> > actually be able to find all the existing strscpy(dst, src, sizeof(dst))
> > cases to jump-start this conversion.
> 
> I did that.  It works.  It's a lot of conversions.
> 
> $ cat str.cpy.cocci
> @@
> expression e1;
> expression e2;
> @@
> 
> - strscpy(e1, e2, sizeof(e1))
> + stracpy(e1, e2)
> 
> @@
> expression e1;
> expression e2;
> @@
> 
> - strlcpy(e1, e2, sizeof(e1))
> + stracpy(e1, e2)
> 
> > Devil's advocate: this adds yet more string handling functions... will
> > this cause even more confusion?
> 
> Documentation is good.
> Actual in-kernel use and examples better.

btw: I just ran this again and it produces:

$ spatch --in-place -sp-file str.cpy.cocci .
$ git checkout tools/
$ git diff --shortstat
 958 files changed, 2179 insertions(+), 2655 deletions(-)



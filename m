Return-Path: <SRS0=v2jA=VT=lists.openwall.com=kernel-hardening-return-16533-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD450C7618F
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jul 2019 18:35:55 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 136EF2190D
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jul 2019 18:35:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 136EF2190D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16533-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22024 invoked by uid 550); 22 Jul 2019 18:35:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21980 invoked from network); 22 Jul 2019 18:35:48 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: sort55_4dc629887d118
X-Filterd-Recvd-Size: 2243
Message-ID: <207e201cb7a36e38f032bcb66e79e2d4b9b63c7b.camel@perches.com>
Subject: Re: [RFC PATCH] string.h: Add stracpy/stracpy_pad (was: Re: [PATCH]
 checkpatch: Added warnings in favor of strscpy().)
From: Joe Perches <joe@perches.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Kees Cook <keescook@chromium.org>, Nitin Gote <nitin.r.gote@intel.com>, 
	akpm@linux-foundation.org, corbet@lwn.net, apw@canonical.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-hardening@lists.openwall.com, Rasmus Villemoes
	 <rasmus.villemoes@prevas.dk>
Date: Mon, 22 Jul 2019 11:35:33 -0700
In-Reply-To: <20190722182703.GE363@bombadil.infradead.org>
References: <1562219683-15474-1-git-send-email-nitin.r.gote@intel.com>
	 <f6a4c2b601bb59179cb2e3b8f4d836a1c11379a3.camel@perches.com>
	 <d1524130f91d7cfd61bc736623409693d2895f57.camel@perches.com>
	 <201907221031.8B87A9DE@keescook>
	 <b9bb5550b264d4b29b2b20f7ff8b1b40d20def6a.camel@perches.com>
	 <2c959c56c23d0052e5c35ecfa2f6051b17fb2798.camel@perches.com>
	 <20190722182703.GE363@bombadil.infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2019-07-22 at 11:27 -0700, Matthew Wilcox wrote:
> On Mon, Jul 22, 2019 at 10:58:15AM -0700, Joe Perches wrote:
> > On Mon, 2019-07-22 at 10:43 -0700, Joe Perches wrote:
> > > On Mon, 2019-07-22 at 10:33 -0700, Kees Cook wrote:
> > > > On Thu, Jul 04, 2019 at 05:15:57PM -0700, Joe Perches wrote:
> > > > > On Thu, 2019-07-04 at 13:46 -0700, Joe Perches wrote:
[]
> > > > > +#define stracpy(to, from)					\
> > > > > +({								\
> > > > > +	size_t size = ARRAY_SIZE(to);				\
> > > > > +	BUILD_BUG_ON(!__same_type(typeof(*to), char));		\
> > > > > +								\
> > > > > +	strscpy(to, from, size);				\
> > > > > +})
> 
> Where does the 'a' in 'stracpy' come from?

No place in particular.

I used it because dst has to be an 'a'rray rather
than a pointer.



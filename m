Return-Path: <SRS0=/BmR=4Q=lists.openwall.com=kernel-hardening-return-18003-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A20C9C3F2D0
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Feb 2020 03:37:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F2F79246A0
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Feb 2020 03:37:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JypYhFcf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F2F79246A0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18003-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20425 invoked by uid 550); 28 Feb 2020 03:37:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20405 invoked from network); 28 Feb 2020 03:37:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1582861019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aDJjztBIb3g7WuQ8tm9j5jVgnbmxznk84OuAMLjRbBQ=;
	b=JypYhFcfjmgKv70T5BssQA2615RgoK0npz9jUJD+tDFVIj+t2Lw6LOBnyPFcGHchr5QhEv
	jaCpKBGA6kdjLW4nyA62wzbzm8toy55S9gsrg3mnmGlIJ5glqSjf3xftOu+FLvgqNisvAD
	LaabFng7dPIdnnLuD0ysthae+jpea9k=
X-MC-Unique: RILYYk35OgShqd8ub0Y2sA-1
Date: Fri, 28 Feb 2020 11:36:48 +0800
From: Baoquan He <bhe@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Kristen Carlson Accardi <kristen@linux.intel.com>, dyoung@redhat.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	arjan@linux.intel.com, rick.p.edgecombe@intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
	kexec@lists.infradead.org
Subject: Re: [RFC PATCH 09/11] kallsyms: hide layout and expose seed
Message-ID: <20200228033648.GJ24216@MiWiFi-R3L-srv>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
 <20200205223950.1212394-10-kristen@linux.intel.com>
 <202002060428.08B14F1@keescook>
 <a915e1eb131551aa766fde4c14de5a3e825af667.camel@linux.intel.com>
 <20200227024253.GA5707@MiWiFi-R3L-srv>
 <202002270802.1CA8B32AC@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202002270802.1CA8B32AC@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14

On 02/27/20 at 08:02am, Kees Cook wrote:
> On Thu, Feb 27, 2020 at 10:42:53AM +0800, Baoquan He wrote:
> > On 02/06/20 at 09:51am, Kristen Carlson Accardi wrote:
> > > On Thu, 2020-02-06 at 04:32 -0800, Kees Cook wrote:
> > 
> > > > In the past, making kallsyms entirely unreadable seemed to break
> > > > weird
> > > > stuff in userspace. How about having an alternative view that just
> > > > contains a alphanumeric sort of the symbol names (and they will
> > > > continue
> > > > to have zeroed addresses for unprivileged users)?
> > > > 
> > > > Or perhaps we wait to hear about this causing a problem, and deal
> > > > with
> > > > it then? :)
> > > > 
> > > 
> > > Yeah - I don't know what people want here. Clearly, we can't leave
> > > kallsyms the way it is. Removing it entirely is a pretty fast way to
> > > figure out how people use it though :).
> > 
> > Kexec-tools and makedumpfile are the users of /proc/kallsyms currently. 
> > We use kallsyms to get page_offset_base and _stext.
> 
> AIUI, those run as root so they'd be able to consume the uncensored
> output.

Yes, they have to be run under root.


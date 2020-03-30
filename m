Return-Path: <SRS0=5gJB=5P=lists.openwall.com=kernel-hardening-return-18292-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74437C43331
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Mar 2020 08:35:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BE76F2073B
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Mar 2020 08:35:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UVTYvaIb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE76F2073B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18292-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22488 invoked by uid 550); 30 Mar 2020 08:35:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22468 invoked from network); 30 Mar 2020 08:35:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1585557294;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VI4VJLvwA2Wnz1xcO7Y+Io0RjGUfdGgCzJ2iSp2r2DU=;
	b=UVTYvaIbt2iDpPLSd2wUCrP3FiEX6kqqmi4YuSkKZ9ayKSRgPjmzdVKZ0kypiA8IPvwi81
	SBL/vN+8G4hMRG8epabS/KiZLsuYA4RRYcV4nYurWr5AHRk3/cpbuQco0h+SZQ+KfChiyd
	hwbZ/k5aB9wfJnZTAFxBBWtTSp1cQX0=
X-MC-Unique: VzhFc2_pNWWc7DodrKjNHA-1
Date: Mon, 30 Mar 2020 10:34:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Adam Zabrocki <pi3@pi3.com.pl>, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, Jann Horn <jannh@google.com>,
	Andy Lutomirski <luto@amacapital.net>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: Re: Curiosity around 'exec_id' and some problems associated with it
Message-ID: <20200330083446.GA13522@redhat.com>
References: <20200324215049.GA3710@pi3.com.pl>
 <202003291528.730A329@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202003291528.730A329@keescook>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22

On 03/29, Kees Cook wrote:
>
> On Tue, Mar 24, 2020 at 10:50:49PM +0100, Adam Zabrocki wrote:
> >
> > In short, if you hold the file descriptor open over an execve() (e.g. share it
> > with child) the old VM is preserved (refcounted) and might be never released.
> > Essentially, mother process' VM will be still in memory (and pointer to it is
> > valid) even if the mother process passed an execve().

This was true after e268337dfe26dfc7efd422a804dbb27977a3cccc, but please see
6d08f2c7139790c ("proc: make sure mem_open() doesn't pin the target's memory"),
iir it was merged soon after the 1st commit.

Oleg.


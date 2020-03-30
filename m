Return-Path: <SRS0=yJfY=5P=lists.openwall.com=kernel-hardening-return-18309-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC87C43331
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Mar 2020 17:20:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 10D9720578
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Mar 2020 17:20:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="UORjw8xf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 10D9720578
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18309-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23801 invoked by uid 550); 30 Mar 2020 17:20:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23766 invoked from network); 30 Mar 2020 17:20:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GhMliyyhvKck+U/IM2gz1ldhvMRyO4M5LcMCOm4Fcy0=;
        b=UORjw8xfgovq6uZOnT5oQrv/4kgJygm8q3iAblXxyBR6Qv8Wn+QswDm4NENT7VQbBY
         M2e/Tuw6E1FkkIcr+v/rqhHIhVKYNHEDZSrPIub3oigQqVKxvUyPndXAN+5kT8/dEe5s
         wJ6L/IRue6LH78eQ/X2CimsyO4AU1SdKMxYS8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GhMliyyhvKck+U/IM2gz1ldhvMRyO4M5LcMCOm4Fcy0=;
        b=Sj8lXf2vDeTbVCILrlKmN0x5SGCQPQ+ZWPMp7mWAnyk8dSeRMCzqu5phT98CGXwMgZ
         uTOcGQC9eorr4+wcGMWUF9epntKYFWTTCkZ9As+4uHr1EjhsOlqtbuUGiJMQlu9+FcDG
         VoWYRiSnb20IksVgt00eudvWSBLNu2pbsVzXdoBrvd7vY3KwmxsrvuDaNWY5n3B/pn4D
         hEsgsl8wpfOPzEzwLEc1jsBdVjxtvfzBk9lzCv/lT5G599ynMZOPDobmplSDxClXqg4v
         vrfbvSBfgs81WaStMfRIBHgiyCaAENkh0fyjQdvZKByXyPlCqECZTzecOTj64aeTtiQC
         cbAA==
X-Gm-Message-State: AGi0PubkhnrfLCvHUE43QCbLfcVecbcT1BEZT9poVCigTDeiHemDkFoi
	cK9BDBkbdsL68epJiOmYoe0GVg==
X-Google-Smtp-Source: APiQypLO66Bncr70Jt+tX2A613FQoNLHRm/juUOpte4V1NJX6oWU5U3CzkLcAOMsbPvV/4fPHZb2NQ==
X-Received: by 2002:a63:e942:: with SMTP id q2mr166658pgj.34.1585588836058;
        Mon, 30 Mar 2020 10:20:36 -0700 (PDT)
Date: Mon, 30 Mar 2020 10:20:33 -0700
From: Kees Cook <keescook@chromium.org>
To: Jann Horn <jannh@google.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	bpf <bpf@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: CONFIG_DEBUG_INFO_BTF and CONFIG_GCC_PLUGIN_RANDSTRUCT
Message-ID: <202003301016.D0E239A0@keescook>
References: <CAG48ez2sZ58VQ4+LJu39H1M0Y98LhRYR19G_fDAPJPBf7imxuw@mail.gmail.com>
 <CAADnVQ+Ux3-D_7ytRJx_Pz4fStRLS1vkM=-tGZ0paoD7n+JCLQ@mail.gmail.com>
 <CAG48ez0ajun-ujQQqhDRooha1F0BZd3RYKvbJ=8SsRiHAQjUzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez0ajun-ujQQqhDRooha1F0BZd3RYKvbJ=8SsRiHAQjUzw@mail.gmail.com>

On Mon, Mar 30, 2020 at 06:17:32PM +0200, Jann Horn wrote:
> On Mon, Mar 30, 2020 at 5:59 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> > On Mon, Mar 30, 2020 at 8:14 AM Jann Horn <jannh@google.com> wrote:
> > >
> > > I noticed that CONFIG_DEBUG_INFO_BTF seems to partly defeat the point
> > > of CONFIG_GCC_PLUGIN_RANDSTRUCT.
> >
> > Is it a theoretical stmt or you have data?
> > I think it's the other way around.
> > gcc-plugin breaks dwarf and breaks btf.
> > But I only looked at gcc patches without applying them.
> 
> Ah, interesting - I haven't actually tested it, I just assumed
> (perhaps incorrectly) that the GCC plugin would deal with DWARF info
> properly.

Yeah, GCC appears to create DWARF before the plugin does the
randomization[1], so it's not an exposure, but yes, struct randomization
is pretty completely incompatible with a bunch of things in the kernel
(by design). I'm happy to add negative "depends" in the Kconfig if it
helps clarify anything.

-Kees

[1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=84052

-- 
Kees Cook

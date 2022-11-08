Return-Path: <kernel-hardening-return-21585-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id BCA69C4332F
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Nov 2022 19:38:49 +0000 (UTC)
Received: (qmail 26427 invoked by uid 550); 8 Nov 2022 19:38:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26369 invoked from network); 8 Nov 2022 19:38:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kAbbHa0MU4YSxghWvSMb9cKPpMmHz+thNxD0lfZcRnE=;
        b=Vo6mB1KdmXqg3bRs5BIpPsiCoMg7kGFMb6EfY4KBG7C+26ABX9fzMad1aFf/qWUeFk
         4wQcvA+8RrCL32Prn9hQJtP95eP+SOkL9xJNPpcce5Ia6uQQ+73mMcDhkJ1JWj1Guh69
         bq/bm6xHlSbkrYjWLKEBymnmUJwNoJkaZXM4w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kAbbHa0MU4YSxghWvSMb9cKPpMmHz+thNxD0lfZcRnE=;
        b=0aVhfqth7ZrgaRUMOKUvyQByFqPeR9bXrQB33ECQNQ5zUCUQMrpTFcomkinebjo2Tt
         SquG7LIoy3oiD89LULH/21lhPbzkmaquZc4/kegepkolBREUJBnOnUkyVa1A5My1G0L7
         qCTRA4kKYeHQA0AK2/gwL7nM9pH3yyHJSuv6xiSQaA/cjXg4mwSemBXb52AY9RBfqF71
         Gzmf3CvCRTEz3UkbbLhp/jKc+ZHW0iPQ4mNctzkJ44SoK0TZ7ABQFSHUAgZEypnyc1X+
         jd2Cg4+hQtg9D6Nczxa6bhNJdDaN0lxkmSdcbFGGnhMc+utvB5Y1i8Lg1bIfHmO9iq4C
         Soqw==
X-Gm-Message-State: ACrzQf0eIAwR4VZmnJyLiCFrC2VfK/DxpWkNRTCJP0U5584uXnYeGRzf
	70v/6KXZb6ByCmTbJRUHJRkzqQ==
X-Google-Smtp-Source: AMsMyM6/U+AxVETsL5YtefxFYQhjs7JeR/fXEmmw1+qiyAQRZZl+u0+IDe3Zk7tBRQQNnk/g8DmWnQ==
X-Received: by 2002:a63:e06:0:b0:46f:6f55:dd44 with SMTP id d6-20020a630e06000000b0046f6f55dd44mr1079752pgl.252.1667936303665;
        Tue, 08 Nov 2022 11:38:23 -0800 (PST)
Date: Tue, 8 Nov 2022 11:38:22 -0800
From: Kees Cook <keescook@chromium.org>
To: Jann Horn <jannh@google.com>
Cc: Solar Designer <solar@openwall.com>, linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	Greg KH <gregkh@linuxfoundation.org>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Seth Jenkins <sethjenkins@google.com>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Andy Lutomirski <luto@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] exit: Put an upper limit on how often we can oops
Message-ID: <202211081100.AA81FBE964@keescook>
References: <20221107201317.324457-1-jannh@google.com>
 <20221107211440.GA4233@openwall.com>
 <CAG48ez2-xUawSs4ji_+0Bnyn_QTiS930UiOypXreU_RhwhVo_w@mail.gmail.com>
 <202211080923.8BAEA9980@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202211080923.8BAEA9980@keescook>

On Tue, Nov 08, 2022 at 09:24:40AM -0800, Kees Cook wrote:
> On Mon, Nov 07, 2022 at 10:48:20PM +0100, Jann Horn wrote:
> > On Mon, Nov 7, 2022 at 10:15 PM Solar Designer <solar@openwall.com> wrote:
> > > On Mon, Nov 07, 2022 at 09:13:17PM +0100, Jann Horn wrote:
> > > > +oops_limit
> > > > +==========
> > > > +
> > > > +Number of kernel oopses after which the kernel should panic when
> > > > +``panic_on_oops`` is not set.
> > >
> > > Rather than introduce this separate oops_limit, how about making
> > > panic_on_oops (and maybe all panic_on_*) take the limit value(s) instead
> > > of being Boolean?  I think this would preserve the current behavior at
> > > panic_on_oops = 0 and panic_on_oops = 1, but would introduce your
> > > desired behavior at panic_on_oops = 10000.  We can make 10000 the new
> > > default.  If a distro overrides panic_on_oops, it probably sets it to 1
> > > like RHEL does.
> > >
> > > Are there distros explicitly setting panic_on_oops to 0?  If so, that
> > > could be a reason to introduce the separate oops_limit.
> > >
> > > I'm not advocating one way or the other - I just felt this should be
> > > explicitly mentioned and decided on.
> > 
> > I think at least internally in the kernel, it probably works better to
> > keep those two concepts separate? For example, sparc has a function
> > die_nmi() that uses panic_on_oops to determine whether the system
> > should panic when a watchdog detects a lockup.
> 
> Internally, yes, the kernel should keep "panic_on_oops" to mean "panic
> _NOW_ on oops?" but I would agree with Solar -- this is a counter as far
> as userspace is concerned. "Panic on Oops" after 1 oops, 2, oopses, etc.
> I would like to see this for panic_on_warn too, actually.

Hm, in looking at this more closely, I think it does make sense as you
already have it. The count is for the panic_on_oops=0 case, so even in
userspace, trying to remap that doesn't make a bunch of sense. So, yes,
let's keep this as-is.

-- 
Kees Cook

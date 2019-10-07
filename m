Return-Path: <SRS0=N6xK=YA=lists.openwall.com=kernel-hardening-return-16995-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,GAPPY_SUBJECT,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0056DC47404
	for <kernel-hardening@archiver.kernel.org>; Mon,  7 Oct 2019 12:41:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4308521655
	for <kernel-hardening@archiver.kernel.org>; Mon,  7 Oct 2019 12:40:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dDiR8orV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4308521655
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16995-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26076 invoked by uid 550); 7 Oct 2019 12:40:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26044 invoked from network); 7 Oct 2019 12:40:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4omqkgEsOa3d7dDrSHEj0fGIcb4u6Z71IZA7jxrxpXA=;
        b=dDiR8orVa3DeLfGPRt48FE0G85MRTPusWnInVoCHTm00UIfVXwiV/+Te1Locr2IaNc
         MzWbl8tv0imbIGqQtxu0ALEcZC1N9Or2EThj5AmzPSVpmoDMVs1i8SsmJ9wVcwlzZkYN
         qBxVgOHEYzZGQe/JFirWQ3b6bW9Kri0w3T2G2dSxfyxekUK0in8Zjncbv0YSi1etbce0
         JUNEKfAP/FqN5fdqbNVuyaE9cVFfymuJwKGB1Puf/w4zhnazPVVK+ecB9rVjdHkGy5Kq
         ofuDjgblAoF8uO+Q0NR67UqHDMKQh/+YhcweREO6rBJatoR9tulV3qfPcv/ObTO73w60
         Slmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4omqkgEsOa3d7dDrSHEj0fGIcb4u6Z71IZA7jxrxpXA=;
        b=LlnDLsFK9y0t6WArx8PFgaad4rd+V3UktPdyO9m+Jtxh1DlyV+j3opwlOmS8q0SjGo
         ikAszPW6gyrhx+JEGs60a3askLezqY2E4vWXnRPHHH1NBI6vqyVBy6hyZewDQPV/mRe1
         m8L3ooviC5jD2m2g46CP4j5JprLoAiJac1XZWWsaxxiKtdJhQYBpEZ3Izj+HPIbJYHg8
         0QsZaXW5ZN5NjGfpsInz5XfzaoqaQQYyqinUHp9a0MpLlVAagZCrCYKFEXyEznRP8EWT
         ACs62qMAqQkxmmY2VpGCbyaQNaLfVbFOCMSce4ZSWZR+sr5T4UkRQcq4ArLSrDPqrhIV
         or2Q==
X-Gm-Message-State: APjAAAUHa1gA1PErscp4iOvBYXcE6GA+3RUD1+CKywczwvpaRSk57ooL
	4J6N7oB15zkJi1NBXeJ7xeG1Yl0v527vUChoHiPyUg==
X-Google-Smtp-Source: APXvYqwhR+z+UIZ4jgopakgOCjtQfQIV/2FB/mG9OzRVEd9xbqmcvQS251+v4BMhDWqCxWTMsQGJ/FkT4gtdl54+U4k=
X-Received: by 2002:aca:ed52:: with SMTP id l79mr17312662oih.47.1570452039482;
 Mon, 07 Oct 2019 05:40:39 -0700 (PDT)
MIME-Version: 1.0
References: <1562410493-8661-1-git-send-email-s.mesoraca16@gmail.com>
 <1562410493-8661-5-git-send-email-s.mesoraca16@gmail.com> <CAG48ez35oJhey5WNzMQR14ko6RPJUJp+nCuAHVUJqX7EPPPokA@mail.gmail.com>
 <CAJHCu1+35GhGJY8jDMPEU8meYhJTVgvzY5sJgVCuLrxCoGgHEg@mail.gmail.com> <CAJHCu1JobL7aj51=4gvaoXPfWH8aNdYXgcBDq90wV4_jN2iUfw@mail.gmail.com>
In-Reply-To: <CAJHCu1JobL7aj51=4gvaoXPfWH8aNdYXgcBDq90wV4_jN2iUfw@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Mon, 7 Oct 2019 14:40:13 +0200
Message-ID: <CAG48ez3v4dpCGBUc16FQDbGEAXtnDDvTq2GQpVax0rLgHEM3_g@mail.gmail.com>
Subject: Re: [PATCH v5 04/12] S.A.R.A.: generic DFA for string matching
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Brad Spengler <spender@grsecurity.net>, 
	Casey Schaufler <casey@schaufler-ca.com>, Christoph Hellwig <hch@infradead.org>, 
	Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Thomas Gleixner <tglx@linutronix.de>, James Morris <jmorris@namei.org>, 
	John Johansen <john.johansen@canonical.com>
Content-Type: text/plain; charset="UTF-8"

On Sun, Oct 6, 2019 at 6:49 PM Salvatore Mesoraca
<s.mesoraca16@gmail.com> wrote:
> Salvatore Mesoraca <s.mesoraca16@gmail.com> wrote:
> > Jann Horn <jannh@google.com> wrote:
> > > On Sat, Jul 6, 2019 at 12:55 PM Salvatore Mesoraca
> > > <s.mesoraca16@gmail.com> wrote:
> > > > Creation of a generic Discrete Finite Automata implementation
> > > > for string matching. The transition tables have to be produced
> > > > in user-space.
> > > > This allows us to possibly support advanced string matching
> > > > patterns like regular expressions, but they need to be supported
> > > > by user-space tools.
> > >
> > > AppArmor already has a DFA implementation that takes a DFA machine
> > > from userspace and runs it against file paths; see e.g.
> > > aa_dfa_match(). Did you look into whether you could move their DFA to
> > > some place like lib/ and reuse it instead of adding yet another
> > > generic rule interface to the kernel?
> >
> > Yes, using AppArmor DFA cloud be a possibility.
> > Though, I didn't know how AppArmor's maintainers feel about this.
> > I thought that was easier to just implement my own.
> > Anyway I understand that re-using that code would be the optimal solution.
> > I'm adding in CC AppArmor's maintainers, let's see what they think about this.
>
> I don't want this to prevent SARA from being up-streamed.
> Do you think that having another DFA here could be acceptable anyway?
> Would it be better if I just drop the DFA an go back to simple string
> matching to speed up things?

While I think that it would be nicer not to have yet another
implementation of the same thing, I don't feel strongly about it.

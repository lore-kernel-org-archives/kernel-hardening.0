Return-Path: <SRS0=E7sr=D4=lists.openwall.com=kernel-hardening-return-20238-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11FC2C561F8
	for <kernel-hardening@archiver.kernel.org>; Wed, 21 Oct 2020 09:04:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DDBA122453
	for <kernel-hardening@archiver.kernel.org>; Wed, 21 Oct 2020 09:04:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDBA122453
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=canonical.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20238-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31771 invoked by uid 550); 21 Oct 2020 09:04:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26399 invoked from network); 20 Oct 2020 20:20:30 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WvOvrqIowXTqWbDC3SiYk9DLPVZO2oaMjHYKa1wNVGk=;
        b=hiHvZbYwLrmxu1Yw44XcKnvuqtjiwE1Ogd73FRl9cGn7aZn7l7udcqs5GSF3iFUl68
         VoatGGLleQHC+yjwz8TmzdudkI/fzFTzWSEve5Bwkw1biH1XaeUBJS2TCXaVlzsw+R0/
         XcaE3TWHhjZklRgtexuVfI24AaBcqwuwPSlW0Oh/M4b6Qv0EqIhSdDwvwqVmmHcxcvH8
         7PmmoDgkyzEZ0V//R0b+cB6aE02qMP7KN2cOfETgXzmlA8TTHdwGOeAZquLTjyw4qBO2
         OsXP56ODOA+fPkJmUT/j6rfOPSqvofw6BfhwTNK8Ye3aDx5OLXx6LuMX/aAszO7k3PqK
         gDBQ==
X-Gm-Message-State: AOAM533vX8B0jpPmKmFPU8Fg0TEepkKaF9XKsM6aR7n6+XZyY4gLCFj7
	gLpLKAARz9G9l009xiKdaDZUdiOHf+V+kZapuJCapPpP+qa+jUiTnP3MjG1Z5U9axAlGd7nfe4s
	mxkZVwtvxBTIV3uMPCG2T8QCVq066xCNzC4CdQV2rirB5cRyUS6f0Ge3H/gRtIMTcuUc=
X-Received: by 2002:a17:907:2079:: with SMTP id qp25mr5120232ejb.347.1603225218451;
        Tue, 20 Oct 2020 13:20:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyqbbW8pMrleDlOJd1KePFqq+CJbaQMJ+psyTG1mR8nQ4SwdBtFh6Yuwue0V+iAwXeGPL4ShGlaEgzeY9wHMIY=
X-Received: by 2002:a17:907:2079:: with SMTP id qp25mr5120206ejb.347.1603225218228;
 Tue, 20 Oct 2020 13:20:18 -0700 (PDT)
MIME-Version: 1.0
References: <20201019182853.7467-1-gpiccoli@canonical.com> <20201020082022.GL27114@dhcp22.suse.cz>
 <9cecd9d9-e25c-4495-50e2-8f7cb7497429@canonical.com> <5650dc95-4ae2-05d3-c71a-3828d35bd49b@redhat.com>
In-Reply-To: <5650dc95-4ae2-05d3-c71a-3828d35bd49b@redhat.com>
From: Guilherme Piccoli <gpiccoli@canonical.com>
Date: Tue, 20 Oct 2020 17:19:42 -0300
Message-ID: <CAHD1Q_wQrnSEGOvbCi0uhHZ5bRf=inzPdOhGKJ9PkVms5GSWRA@mail.gmail.com>
Subject: Re: [PATCH] mm, hugetlb: Avoid double clearing for hugetlb pages
To: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, 
	kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org, 
	linux-security-module@vger.kernel.org, 
	"Guilherme G. Piccoli" <kernel@gpiccoli.net>, 
	Thadeu Lima de Souza Cascardo <cascardo@canonical.com>, Alexander Potapenko <glider@google.com>, 
	James Morris <jamorris@linux.microsoft.com>, Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"

When I first wrote that, the design was a bit different, the flag was
called __GFP_HTLB_PAGE or something like that. The design was to
signal/mark the composing pages of hugetlb as exactly this: they are
pages composing a huge page of hugetlb "type". Then, I skipped the
"init_on_alloc" thing for such pages.

If your concern is more about semantics (or giving multiple users,
like drivers, the power to try "optimize" their code and skip this
security feature), I think my first approach was better! This way, the
flag would be restricted to hugetlb usage only.
I've changed my mind about that approach before submitting for 2 reasons:

(a) It feels a waste of resources having a GFP flag *only* to signal
regular pages composing hugetlb pages, it's a single user only,
forever!
(b) Having 2 conditional settings on __GFP_BITS_SHIFT (LOCKDEP and
HUGETLB) started to make this define a bit tricky to code, since we'd
have 2 Kconfig-conditional bits to be set.

So, I've moved to this other approach, hereby submitted.
Cheers,


Guilherme

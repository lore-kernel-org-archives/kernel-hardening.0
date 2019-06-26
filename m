Return-Path: <SRS0=FdSP=UZ=lists.openwall.com=kernel-hardening-return-16262-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57B90C48BD6
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Jun 2019 15:42:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BAD822177B
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Jun 2019 15:42:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BAD822177B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16262-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9881 invoked by uid 550); 26 Jun 2019 15:42:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9863 invoked from network); 26 Jun 2019 15:42:50 -0000
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Date: Wed, 26 Jun 2019 17:42:37 +0200
From: Michal Hocko <mhocko@kernel.org>
To: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Kostya Serebryany <kcc@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Sandeep Patil <sspatil@android.com>,
	Laura Abbott <labbott@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>,
	Mark Rutland <mark.rutland@arm.com>, Marco Elver <elver@google.com>,
	Qian Cai <cai@lca.pw>,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-security-module <linux-security-module@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH v8 1/2] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Message-ID: <20190626154237.GZ17798@dhcp22.suse.cz>
References: <20190626121943.131390-1-glider@google.com>
 <20190626121943.131390-2-glider@google.com>
 <20190626144943.GY17798@dhcp22.suse.cz>
 <CAG_fn=Xf5yEuz7JyOt-gmNx1uSM6mmM57_jFxCi+9VPZ4PSwJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG_fn=Xf5yEuz7JyOt-gmNx1uSM6mmM57_jFxCi+9VPZ4PSwJQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed 26-06-19 17:00:43, Alexander Potapenko wrote:
> On Wed, Jun 26, 2019 at 4:49 PM Michal Hocko <mhocko@kernel.org> wrote:
[...]
> > > @@ -1142,6 +1200,8 @@ static __always_inline bool free_pages_prepare(struct page *page,
> > >       }
> > >       arch_free_page(page, order);
> > >       kernel_poison_pages(page, 1 << order, 0);
> > > +     if (want_init_on_free())
> > > +             kernel_init_free_pages(page, 1 << order);
> >
> > same here. If you don't want to make this exclusive then you have to
> > zero before poisoning otherwise you are going to blow up on the poison
> > check, right?
> Note that we disable initialization if page poisoning is on.

Ohh, right. Missed that in the init code.

> As I mentioned on another thread we can eventually merge this code
> with page poisoning, but right now it's better to make the user decide
> which of the features they want instead of letting them guess how the
> combination of the two is going to work.

Strictly speaking zeroying is a subset of poisoning. If somebody asks
for both the poisoning surely satisfies any data leak guarantees
zeroying would give. So I am not sure we have to really make them
exclusive wrt. to the configuraion. I will leave that to you but it
would be better if the code didn't break subtly once the early init
restriction is removed for one way or another. So either always make
sure that zeroying is done _before_ poisoning or that you do not zero
when poisoning. The later sounds the best wrt. the code quality from my
POV.

-- 
Michal Hocko
SUSE Labs

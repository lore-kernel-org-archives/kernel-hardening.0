Return-Path: <SRS0=vOBe=U2=lists.openwall.com=kernel-hardening-return-16280-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D673AC48BD7
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 06:15:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 396D8204FD
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 06:15:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 396D8204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16280-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7715 invoked by uid 550); 27 Jun 2019 06:15:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7694 invoked from network); 27 Jun 2019 06:15:48 -0000
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Date: Thu, 27 Jun 2019 08:15:34 +0200
From: Michal Hocko <mhocko@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Qian Cai <cai@lca.pw>, Catalin Marinas <catalin.marinas@arm.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>,
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
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	clang-built-linux@googlegroups.com
Subject: Re: [PATCH v8 1/2] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Message-ID: <20190627061534.GA17798@dhcp22.suse.cz>
References: <20190626121943.131390-1-glider@google.com>
 <20190626121943.131390-2-glider@google.com>
 <1561572949.5154.81.camel@lca.pw>
 <201906261303.020ADC9@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201906261303.020ADC9@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed 26-06-19 13:23:34, Kees Cook wrote:
> On Wed, Jun 26, 2019 at 02:15:49PM -0400, Qian Cai wrote:
> > On Wed, 2019-06-26 at 14:19 +0200, Alexander Potapenko wrote:
> > > Both init_on_alloc and init_on_free default to zero, but those defaults
> > > can be overridden with CONFIG_INIT_ON_ALLOC_DEFAULT_ON and
> > > CONFIG_INIT_ON_FREE_DEFAULT_ON.
> > > [...]
> > > +static int __init early_init_on_alloc(char *buf)
> > > +{
> > > +	int ret;
> > > +	bool bool_result;
> > > +
> > > +	if (!buf)
> > > +		return -EINVAL;
> > > +	ret = kstrtobool(buf, &bool_result);
> > > +	if (bool_result)
> > > +		static_branch_enable(&init_on_alloc);
> > > +	else
> > > +		static_branch_disable(&init_on_alloc);
> > > +	return ret;
> > > +}
> > > +early_param("init_on_alloc", early_init_on_alloc);
> > 
> > Do those really necessary need to be static keys?
> > 
> > Adding either init_on_free=0 or init_on_alloc=0 to the kernel cmdline will
> > generate a warning with kernels built with clang.
> > 
> > [    0.000000] static_key_disable(): static key 'init_on_free+0x0/0x4' used
> > before call to jump_label_init()
> > [    0.000000] WARNING: CPU: 0 PID: 0 at ./include/linux/jump_label.h:317
> > early_init_on_free+0x1c0/0x200
> > [    0.000000] Modules linked in:
> > [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 5.2.0-rc6-next-20190626+
> > #9
> > [    0.000000] pstate: 60000089 (nZCv daIf -PAN -UAO)
> 
> I think the issue here is that arm64 doesn't initialize static keys
> early enough.

This sounds familiar: http://lkml.kernel.org/r/CABXOdTd-cqHM_feAO1tvwn4Z=kM6WHKYAbDJ7LGfMvRPRPG7GA@mail.gmail.com
-- 
Michal Hocko
SUSE Labs

Return-Path: <SRS0=n1yR=VM=lists.openwall.com=kernel-hardening-return-16470-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2EE5C76191
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Jul 2019 20:02:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3358420665
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Jul 2019 20:02:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zpmgc+90"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3358420665
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16470-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13444 invoked by uid 550); 15 Jul 2019 20:02:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13423 invoked from network); 15 Jul 2019 20:02:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563220956;
	bh=YctKhCkISL0QPipV+bux3pgwhg/+Wfr5uFkoRtTAvW4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zpmgc+90naNM5ZNKifvDCcoZ3spBOmMeL6aUQCdQN6DChBG1dtV+fiAmUZdgdt7Nv
	 WepQllK+1iqQA9GayKjQYU7a8D6suBSxT0G6Ps5JjrhQxY6MeINoIye7/tO5Ql8yWg
	 wSYw4E9KxCddQ4CbrfQgZiLypFMsonffeLgLmMiw=
Date: Mon, 15 Jul 2019 15:02:35 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	Borislav Petkov <bp@alien8.de>, c0d1n61at3@gmail.com,
	"David S. Miller" <davem@davemloft.net>, edumazet@google.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
	kernel-hardening@lists.openwall.com, kernel-team@android.com,
	Lai Jiangshan <jiangshanlai@gmail.com>, Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, neilb@suse.com,
	netdev@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.ibm.com>,
	Pavel Machek <pavel@ucw.cz>, peterz@infradead.org,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Rasmus Villemoes <rasmus.villemoes@prevas.dk>, rcu@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH 7/9] x86/pci: Pass lockdep condition to pcm_mmcfg_list
 iterator (v1)
Message-ID: <20190715200235.GG46935@google.com>
References: <20190715143705.117908-1-joel@joelfernandes.org>
 <20190715143705.117908-8-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715143705.117908-8-joel@joelfernandes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Jul 15, 2019 at 10:37:03AM -0400, Joel Fernandes (Google) wrote:
> The pcm_mmcfg_list is traversed with list_for_each_entry_rcu without a
> reader-lock held, because the pci_mmcfg_lock is already held. Make this
> known to the list macro so that it fixes new lockdep warnings that
> trigger due to lockdep checks added to list_for_each_entry_rcu().
> 
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

Ingo takes care of most patches to this file, but FWIW,

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

I would personally prefer if you capitalized the subject to match the
"x86/PCI:" convention that's used fairly consistently in
arch/x86/pci/.

Also, I didn't apply this to be sure, but it looks like this might
make a line or two wider than 80 columns, which I would rewrap if I
were applying this.

> ---
>  arch/x86/pci/mmconfig-shared.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
> index 7389db538c30..6fa42e9c4e6f 100644
> --- a/arch/x86/pci/mmconfig-shared.c
> +++ b/arch/x86/pci/mmconfig-shared.c
> @@ -29,6 +29,7 @@
>  static bool pci_mmcfg_running_state;
>  static bool pci_mmcfg_arch_init_failed;
>  static DEFINE_MUTEX(pci_mmcfg_lock);
> +#define pci_mmcfg_lock_held() lock_is_held(&(pci_mmcfg_lock).dep_map)
>  
>  LIST_HEAD(pci_mmcfg_list);
>  
> @@ -54,7 +55,7 @@ static void list_add_sorted(struct pci_mmcfg_region *new)
>  	struct pci_mmcfg_region *cfg;
>  
>  	/* keep list sorted by segment and starting bus number */
> -	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list) {
> +	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list, pci_mmcfg_lock_held()) {
>  		if (cfg->segment > new->segment ||
>  		    (cfg->segment == new->segment &&
>  		     cfg->start_bus >= new->start_bus)) {
> @@ -118,7 +119,7 @@ struct pci_mmcfg_region *pci_mmconfig_lookup(int segment, int bus)
>  {
>  	struct pci_mmcfg_region *cfg;
>  
> -	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list)
> +	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list, pci_mmcfg_lock_held())
>  		if (cfg->segment == segment &&
>  		    cfg->start_bus <= bus && bus <= cfg->end_bus)
>  			return cfg;
> -- 
> 2.22.0.510.g264f2c817a-goog
> 

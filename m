Return-Path: <SRS0=c6Bq=VJ=lists.openwall.com=kernel-hardening-return-16429-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39C06C742D5
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Jul 2019 17:00:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 660A220665
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Jul 2019 17:00:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="QUdJPbnU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 660A220665
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16429-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30497 invoked by uid 550); 12 Jul 2019 17:00:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30477 invoked from network); 12 Jul 2019 17:00:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4R73ECcFsgEJ+nDrVGaF7lXHe3UNCLl3CB9t/q9lNT4=;
        b=QUdJPbnULiAaQGPSi2mqi0K5L8ZUkC7IX+RSaHrjNxvLiFWoKFYBoo/oGR4kaJ+If5
         H+hJo/HgYMGa2Q0AVqNqfSZ4wCuzsyweIdbuCBwCruxs20caVT8lckLIacvRNFQKWd4U
         5aEnPHEBflrCxzDnwhzGkmd+pAsgTBSfog6z8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4R73ECcFsgEJ+nDrVGaF7lXHe3UNCLl3CB9t/q9lNT4=;
        b=PFMS9fIRfnSa5DBP5F5jUWtXJTQmHkVM5eQqkEGJDpZXbnJdDnvhhrc0N6fQGtS+Ef
         1c05KiTOltw2XvsDvC1obQuRGVbmGbdOKgmIvmkSDzOf2hcZlY6qA5IJqsTJklhoLLaY
         ja9moDdlv7zpACZJ1ZMlw9MXNdV2+7t6huXtmBay0WBOIQPxfGkpVxnN95bTVDxFUnUn
         WpBkekaszll901Phww98wrxjz3IONLlWWYY9SrpwbAMjbajv6nJtikyHhfEOwqNCOKJA
         Qiv0KG27YtaYAFzJ6P4o9+U8ATb3o1bYYBqh5YHHod5O5wXme8S6OCJ2a3DCOHgSmP+C
         S5pw==
X-Gm-Message-State: APjAAAXd+6aftynltv/qg8DNcVdXW5N4emzEJ1tm+haA1t9f6bW07uiI
	l/auvvR4F4zM+uft0m8TnDQ=
X-Google-Smtp-Source: APXvYqy/IfEk1KCS4o5ZDngZgPwSlK051hwLHg+0U99vqOwQGBX28IMyNjvCo8ritYeQERfyu/T2Kw==
X-Received: by 2002:a17:902:296a:: with SMTP id g97mr12356829plb.115.1562950833539;
        Fri, 12 Jul 2019 10:00:33 -0700 (PDT)
From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
To: linux-kernel@vger.kernel.org
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>,
	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Borislav Petkov <bp@alien8.de>,
	c0d1n61at3@gmail.com,
	"David S. Miller" <davem@davemloft.net>,
	edumazet@google.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Triplett <josh@joshtriplett.org>,
	keescook@chromium.org,
	kernel-hardening@lists.openwall.com,
	kernel-team@android.com,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-pm@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	neilb@suse.com,
	netdev@vger.kernel.org,
	Oleg Nesterov <oleg@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.ibm.com>,
	Pavel Machek <pavel@ucw.cz>,
	peterz@infradead.org,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
	rcu@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	will@kernel.org,
	x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT))
Subject: [PATCH v2 0/9] Harden list_for_each_entry_rcu() and family
Date: Fri, 12 Jul 2019 13:00:15 -0400
Message-Id: <20190712170024.111093-1-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,
This series aims to provide lockdep checking to RCU list macros for additional
kernel hardening.

RCU has a number of primitives for "consumption" of an RCU protected pointer.
Most of the time, these consumers make sure that such accesses are under a RCU
reader-section (such as rcu_dereference{,sched,bh} or under a lock, such as
with rcu_dereference_protected()).

However, there are other ways to consume RCU pointers, such as by
list_for_each_entry_rcu or hlist_for_each_enry_rcu. Unlike the rcu_dereference
family, these consumers do no lockdep checking at all. And with the growing
number of RCU list uses (1000+), it is possible for bugs to creep in and go
unnoticed which lockdep checks can catch.

Since RCU consolidation efforts last year, the different traditional RCU
flavors (preempt, bh, sched) are all consolidated. In other words, any of these
flavors can cause a reader section to occur and all of them must cease before
the reader section is considered to be unlocked. Thanks to this, we can
generically check if we are in an RCU reader. This is what patch 1 does. Note
that the list_for_each_entry_rcu and family are different from the
rcu_dereference family in that, there is no _bh or _sched version of this
macro. They are used under many different RCU reader flavors, and also SRCU.
Patch 1 adds a new internal function rcu_read_lock_any_held() which checks
if any reader section is active at all, when these macros are called. If no
reader section exists, then the optional fourth argument to
list_for_each_entry_rcu() can be a lockdep expression which is evaluated
(similar to how rcu_dereference_check() works). If no lockdep expression is
passed, and we are not in a reader, then a splat occurs. Just take off the
lockdep expression after applying the patches, by using the following diff and
see what happens:

+++ b/arch/x86/pci/mmconfig-shared.c
@@ -55,7 +55,7 @@ static void list_add_sorted(struct pci_mmcfg_region *new)
        struct pci_mmcfg_region *cfg;

        /* keep list sorted by segment and starting bus number */
-       list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list, pci_mmcfg_lock_held()) {
+       list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list) {


The optional argument trick to list_for_each_entry_rcu() can also be used in
the future to possibly remove rcu_dereference_{,bh,sched}_protected() API and
we can pass an optional lockdep expression to rcu_dereference() itself. Thus
eliminating 3 more RCU APIs.

Note that some list macro wrappers already do their own lockdep checking in the
caller side. These can be eliminated in favor of the built-in lockdep checking
in the list macro that this series adds. For example, workqueue code has a
assert_rcu_or_wq_mutex() function which is called in for_each_wq().  This
series replaces that in favor of the built-in check.

Also in the future, we can extend these checks to list_entry_rcu() and other
list macros as well, if needed.

Please note that I have kept this option default-disabled under a new config:
CONFIG_PROVE_RCU_LIST. This is so that until all users are converted to pass
the optional argument, we should keep the check disabled. There are about a
1000 or so users and it is not possible to pass in the optional lockdep
expression in a single series since it is done on a case-by-case basis. I did
convert a few users in this series itself.



v1->v2: Have assert_rcu_or_wq_mutex deleted (Daniel Jordan)
	Simplify rcu_read_lock_any_held()   (Peter Zijlstra)
	Simplified rcu-sync logic	    (Oleg Nesterov)
	Updated documentation and rculist comments.
	Added GregKH ack.

RFC->v1: 
	Simplify list checking macro (Rasmus Villemoes)

Joel Fernandes (Google) (9):
rcu/update: Remove useless check for debug_locks
rcu: Add support for consolidated-RCU reader checking
rcu/sync: Remove custom check for reader-section
ipv4: add lockdep condition to fix for_each_entry
driver/core: Convert to use built-in RCU list checking
workqueue: Convert for_each_wq to use built-in list check
x86/pci: Pass lockdep condition to pcm_mmcfg_list iterator
acpi: Use built-in RCU list checking for acpi_ioremaps list
doc: Update documentation about list_for_each_entry_rcu

Documentation/RCU/lockdep.txt   | 15 +++++++++++----
Documentation/RCU/whatisRCU.txt |  9 ++++++++-
arch/x86/pci/mmconfig-shared.c  |  5 +++--
drivers/acpi/osl.c              |  6 ++++--
drivers/base/base.h             |  1 +
drivers/base/core.c             | 10 ++++++++++
drivers/base/power/runtime.c    | 15 ++++++++++-----
include/linux/rcu_sync.h        |  5 ++---
include/linux/rculist.h         | 28 +++++++++++++++++++++++-----
include/linux/rcupdate.h        |  7 +++++++
kernel/rcu/Kconfig.debug        | 11 +++++++++++
kernel/rcu/sync.c               | 22 ----------------------
kernel/rcu/update.c             | 20 +++++++++++++++-----
kernel/workqueue.c              | 10 ++--------
net/ipv4/fib_frontend.c         |  3 ++-
15 files changed, 109 insertions(+), 58 deletions(-)

--
2.22.0.510.g264f2c817a-goog


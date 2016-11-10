Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 10 Nov 2016 22:35:35 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161110213535.GA3117@twins.programming.kicks-ass.net>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
 <1478809488-18303-2-git-send-email-elena.reshetova@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1478809488-18303-2-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] Re: [RFC v4 PATCH 01/13] Add architecture independent hardened
 atomic base
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, will.deacon@arm.com, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 10, 2016 at 10:24:36PM +0200, Elena Reshetova wrote:
>  include/asm-generic/local.h                |   3 +
>  include/asm-generic/local_wrap.h           |  63 +++++++++++

Seriously? Is there a single instance of local_t where any of this
matters?

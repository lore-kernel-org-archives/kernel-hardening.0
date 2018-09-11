MIME-Version: 1.0
References: <20180910191002.350195-1-kristen@linux.intel.com>
In-Reply-To: <20180910191002.350195-1-kristen@linux.intel.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 11 Sep 2018 20:02:53 +0200
Message-ID: <CAG48ez1=_mtYTXvE=eeA6FkEjeZQsnqRJAtzZ75nyeoZuEtmnQ@mail.gmail.com>
Subject: Re: [RFC PATCH] x86: entry: flush the cache if syscall error
Content-Type: text/plain; charset="UTF-8"
To: kristen@linux.intel.com
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Sep 10, 2018 at 9:14 PM Kristen Carlson Accardi
<kristen@linux.intel.com> wrote:
> This patch aims to make it harder to perform cache timing attacks on data
> left behind by system calls. If we have an error returned from a syscall,
> flush the L1 cache.

How much protection does this provide, given that it e.g. doesn't
flush L2/L3 and doesn't prevent data leakage through hyperthreading
and cache coherency? Is an L2/L3-based attack expected to be harder
than an L1D-based one?

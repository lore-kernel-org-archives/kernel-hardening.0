Date: Tue, 11 Sep 2018 09:06:15 -0700
From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [RFC PATCH] x86: entry: flush the cache if syscall error
Message-ID: <20180911160614.GA736@sol.localdomain>
References: <20180910191002.350195-1-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180910191002.350195-1-kristen@linux.intel.com>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Sep 10, 2018 at 12:10:02PM -0700, Kristen Carlson Accardi wrote:
> This patch aims to make it harder to perform cache timing attacks on data
> left behind by system calls. If we have an error returned from a syscall,
> flush the L1 cache.

Which L1 cache?  There's no guarantee the task stayed on the same CPU...

- Eric

Message-ID: <1536773389.3240.4.camel@linux.intel.com>
Subject: Re: [RFC PATCH] x86: entry: flush the cache if syscall error
From: Kristen C Accardi <kristen@linux.intel.com>
Date: Wed, 12 Sep 2018 10:29:49 -0700
In-Reply-To: <20180911160614.GA736@sol.localdomain>
References: <20180910191002.350195-1-kristen@linux.intel.com>
	 <20180911160614.GA736@sol.localdomain>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Eric Biggers <ebiggers@kernel.org>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2018-09-11 at 09:06 -0700, Eric Biggers wrote:
> On Mon, Sep 10, 2018 at 12:10:02PM -0700, Kristen Carlson Accardi
> wrote:
> > This patch aims to make it harder to perform cache timing attacks
> > on data
> > left behind by system calls. If we have an error returned from a
> > syscall,
> > flush the L1 cache.
> 
> Which L1 cache?  There's no guarantee the task stayed on the same
> CPU...

While this is true, it is unlikely that the task switched CPUs for this
type of flow (i.e. an error path, presumably caught early-ish), and
worst case this would just mean we were wiping the wrong cache. I can
add a comment to indicate this scenario.

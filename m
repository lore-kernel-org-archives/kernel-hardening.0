Date: Tue, 24 Apr 2018 04:50:50 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 7/9] Pmalloc Rare Write: modify selected pools
Message-ID: <20180424115050.GD26636@bombadil.infradead.org>
References: <20180423125458.5338-1-igor.stoppa@huawei.com>
 <20180423125458.5338-8-igor.stoppa@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180423125458.5338-8-igor.stoppa@huawei.com>
To: Igor Stoppa <igor.stoppa@gmail.com>
Cc: keescook@chromium.org, paul@paul-moore.com, sds@tycho.nsa.gov, mhocko@kernel.org, corbet@lwn.net, labbott@redhat.com, linux-cc=david@fromorbit.com, --cc=rppt@linux.vnet.ibm.com, --security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Igor Stoppa <igor.stoppa@huawei.com>, Carlos Chinea Perez <carlos.chinea.perez@huawei.com>, Remi Denis Courmont <remi.denis.courmont@huawei.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 23, 2018 at 04:54:56PM +0400, Igor Stoppa wrote:
> While the vanilla version of pmalloc provides support for permanently
> transitioning between writable and read-only of a memory pool, this
> patch seeks to support a separate class of data, which would still
> benefit from write protection, most of the time, but it still needs to
> be modifiable. Maybe very seldom, but still cannot be permanently marked
> as read-only.

This seems like a horrible idea that basically makes this feature useless.
I would say the right way to do this is to have:

struct modifiable_data {
	struct immutable_data *d;
	...
};

Then allocate a new pool, change d and destroy the old pool.

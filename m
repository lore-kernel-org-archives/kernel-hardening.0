References: <20170705134628.3803-1-igor.stoppa@huawei.com>
 <20170705134628.3803-2-igor.stoppa@huawei.com>
 <20170706162742.GA2919@redhat.com>
 <1665fd00-5908-2399-577d-1972c7d1c63b@huawei.com>
 <20170707184843.GA3113@redhat.com>
From: Igor Stoppa <igor.stoppa@huawei.com>
Message-ID: <774d9fc1-4caf-a6c9-3693-a90b5b954645@huawei.com>
Date: Mon, 10 Jul 2017 18:15:53 +0300
MIME-Version: 1.0
In-Reply-To: <20170707184843.GA3113@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 1/3] Protectable memory support
To: Jerome Glisse <jglisse@redhat.com>
Cc: keescook@chromium.org, mhocko@kernel.org, jmorris@namei.org, labbott@redhat.com, hch@infradead.org, penguin-kernel@I-love.SAKURA.ne.jp, paul@paul-moore.com, sds@tycho.nsa.gov, casey@schaufler-ca.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 07/07/17 21:48, Jerome Glisse wrote:

> I believe there is enough unuse field that for vmalloc pages that
> you should find one you can use. Just add some documentation in
> mm_types.h so people are aware of alternate use for the field you
> are using.


I ended up using page->private and the corresponding bit.
Because page-private is an opaque field, specifically reserved for the
allocator, I think it should not be necessary to modify mm_types.h

The reworked patch is here:
https://marc.info/?l=linux-mm&m=149969928920772&w=2

--
thanks, igor

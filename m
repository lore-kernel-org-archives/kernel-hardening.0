Date: Mon, 5 Feb 2018 09:33:15 -0600 (CST)
From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH 3/6] struct page: add field for vm_struct
In-Reply-To: <a12afe9b-79cf-d5c1-3795-89fbf61c6c9d@huawei.com>
Message-ID: <alpine.DEB.2.20.1802050931190.10647@nuc-kabylake>
References: <20180130151446.24698-1-igor.stoppa@huawei.com> <20180130151446.24698-4-igor.stoppa@huawei.com> <alpine.DEB.2.20.1801311758340.21272@nuc-kabylake> <48fde114-d063-cfbf-e1b6-262411fcd963@huawei.com> <alpine.DEB.2.20.1802021240370.31548@nuc-kabylake>
 <a12afe9b-79cf-d5c1-3795-89fbf61c6c9d@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Igor Stoppa <igor.stoppa@huawei.com>
Cc: jglisse@redhat.com, keescook@chromium.org, mhocko@kernel.org, labbott@redhat.com, hch@infradead.org, willy@infradead.org, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, 3 Feb 2018, Igor Stoppa wrote:

> - the property of the compound page will affect the property of all the
> pages in the compound, so when one is write protected, it can generate a
> lot of wasted memory, if there is too much slack (because of the order)
> With vmalloc, I can allocate any number of pages, minimizing the waste.

I thought the intend here is to create a pool where the whole pool becomes
RO?

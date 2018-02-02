Subject: Re: [PATCH 3/6] struct page: add field for vm_struct
References: <20180130151446.24698-1-igor.stoppa@huawei.com>
 <20180130151446.24698-4-igor.stoppa@huawei.com>
 <alpine.DEB.2.20.1801311758340.21272@nuc-kabylake>
 <48fde114-d063-cfbf-e1b6-262411fcd963@huawei.com>
 <CAGXu5jKKeJL13dcaY=fDJ8AiOXDP5MhQTqDYDOt3a374CFA1HQ@mail.gmail.com>
From: Igor Stoppa <igor.stoppa@huawei.com>
Message-ID: <938d71a3-323a-1af3-3815-cd5e1b9813c9@huawei.com>
Date: Fri, 2 Feb 2018 18:01:27 +0200
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKKeJL13dcaY=fDJ8AiOXDP5MhQTqDYDOt3a374CFA1HQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>
Cc: Christopher Lameter <cl@linux.com>, jglisse@redhat.com, Michal Hocko <mhocko@kernel.org>, Laura Abbott <labbott@redhat.com>, Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <willy@infradead.org>, linux-security-module <linux-security-module@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>



On 01/02/18 23:11, Kees Cook wrote:

> IIUC, he means PageHead(), which is also hard to grep for, since it is
> a constructed name, via Page##uname in include/linux/page-flags.h:
> 
> __PAGEFLAG(Head, head, PF_ANY) CLEARPAGEFLAG(Head, head, PF_ANY)

Thank you, I'll try to provide a meaningful reply soon, but I'll be AFK
during most of next 2 weeks, so it might be delayed :-(

--
igor

References: <20170605192216.21596-1-igor.stoppa@huawei.com>
 <20170605192216.21596-4-igor.stoppa@huawei.com>
 <CAG48ez1VMPLasTypDX5QnZnYprbCXfG9ZP9jQvPpS=HCpgvHvQ@mail.gmail.com>
From: Igor Stoppa <igor.stoppa@huawei.com>
Message-ID: <71a18a70-45c9-d75c-db47-3edf41b25a72@huawei.com>
Date: Tue, 6 Jun 2017 12:00:57 +0300
MIME-Version: 1.0
In-Reply-To: <CAG48ez1VMPLasTypDX5QnZnYprbCXfG9ZP9jQvPpS=HCpgvHvQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH 3/5] Protectable Memory Allocator -
 Debug interface
To: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>, mhocko@kernel.org, jmorris@namei.org, penguin-kernel@i-love.sakura.ne.jp, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, casey@schaufler-ca.com, Christoph Hellwig <hch@infradead.org>, labbott@redhat.com, linux-mm@kvack.org, kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>



On 05/06/17 23:24, Jann Horn wrote:
> On Mon, Jun 5, 2017 at 9:22 PM, Igor Stoppa <igor.stoppa@huawei.com> wrote:
>> Debugfs interface: it creates a file

[...]

> You should probably be using %pK to hide the kernel pointers.

ok, will do

---
igor

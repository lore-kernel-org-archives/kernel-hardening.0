MIME-Version: 1.0
In-Reply-To: <20170605192216.21596-4-igor.stoppa@huawei.com>
References: <20170605192216.21596-1-igor.stoppa@huawei.com> <20170605192216.21596-4-igor.stoppa@huawei.com>
From: Jann Horn <jannh@google.com>
Date: Mon, 5 Jun 2017 22:24:20 +0200
Message-ID: <CAG48ez1VMPLasTypDX5QnZnYprbCXfG9ZP9jQvPpS=HCpgvHvQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH 3/5] Protectable Memory Allocator -
 Debug interface
To: Igor Stoppa <igor.stoppa@huawei.com>
Cc: Kees Cook <keescook@chromium.org>, mhocko@kernel.org, jmorris@namei.org, penguin-kernel@i-love.sakura.ne.jp, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, casey@schaufler-ca.com, Christoph Hellwig <hch@infradead.org>, labbott@redhat.com, linux-mm@kvack.org, kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 5, 2017 at 9:22 PM, Igor Stoppa <igor.stoppa@huawei.com> wrote:
> Debugfs interface: it creates a file
>
> /sys/kernel/debug/pmalloc/pools
>
> which exposes statistics about all the pools and memory nodes in use.
>
> Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>
[...]
> +       seq_printf(s, " - node:\t\t%p\n", node);
> +       seq_printf(s, "   - start of data ptr:\t%p\n", node->data);
> +       seq_printf(s, "   - end of node ptr:\t%p\n", (void *)end_of_node);
[...]
> +       seq_printf(s, "pool:\t\t\t%p\n", pool);
[...]
> +       debugfs_create_file("pools", 0644, pmalloc_root, NULL,
> +                           &pmalloc_file_ops);

You should probably be using %pK to hide the kernel pointers.

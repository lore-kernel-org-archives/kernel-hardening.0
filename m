Subject: Re: [RFC PATCH] Randomization of address chosen by mmap.
References: <20180227131338.3699-1-blackzert@gmail.com>
 <CAGXu5jKF7ysJqj57ZktrcVL4G2NWOFHCud8dtXFHLs=tvVLXnQ@mail.gmail.com>
From: lazytyped <lazytyped@gmail.com>
Message-ID: <089e9c52-f623-085a-4d8b-d91cfc6a3608@gmail.com>
Date: Tue, 27 Feb 2018 22:31:38 +0100
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKF7ysJqj57ZktrcVL4G2NWOFHCud8dtXFHLs=tvVLXnQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Kees Cook <keescook@chromium.org>, Ilya Smith <blackzert@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Michal Hocko <mhocko@suse.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Jan Kara <jack@suse.cz>, Jerome Glisse <jglisse@redhat.com>, Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>, Helge Deller <deller@gmx.de>, Andrea Arcangeli <aarcange@redhat.com>, Oleg Nesterov <oleg@redhat.com>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>



On 2/27/18 9:52 PM, Kees Cook wrote:
> I'd like more details on the threat model here; if it's just a matter
> of .so loading order, I wonder if load order randomization would get a
> comparable level of uncertainty without the memory fragmentation,

This also seems to assume that leaking the address of one single library
isn't enough to mount a ROP attack to either gain enough privileges or
generate a primitive that can leak further information. Is this really
the case? Do you have some further data around this?


       -  twiz

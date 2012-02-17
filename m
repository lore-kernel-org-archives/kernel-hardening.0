Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <4F3DA901.8030609@zytor.com>
Date: Thu, 16 Feb 2012 17:10:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <1329422549-16407-1-git-send-email-wad@chromium.org> <1329422549-16407-3-git-send-email-wad@chromium.org> <4F3D61CB.2000301@zytor.com> <CABqD9hb3WxKxLZ2GuUrbDM--koW+a3ser5TU8y6+e0sAhOT9dw@mail.gmail.com> <4F3D7250.6040504@zytor.com> <501858544d264abc6526f2b25a224f2b.squirrel@webmail.greenhost.nl> <CAObL_7G7CvCVgjR-JYjNDi_Sy65UHXaqas4-sQCVej-4bX2PJA@mail.gmail.com>
In-Reply-To: <CAObL_7G7CvCVgjR-JYjNDi_Sy65UHXaqas4-sQCVej-4bX2PJA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v8 3/8] seccomp: add system call filtering using BPF
To: Andrew Lutomirski <luto@mit.edu>
Cc: Indan Zupancic <indan@nul.nu>, Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com, netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de, davem@davemloft.net, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de, eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com, pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

On 02/16/2012 04:51 PM, Andrew Lutomirski wrote:
> 
> IMO the best solution is to have the One True Seccomp Filter Compiler
> (tm).  It would handle multiple namespaces, cross-arch differences,
> and such, and it would do it correctly.  It could live in the kernel
> tree.
> 
> Without something like that or an incredible amount of special care,
> actual portability is probably a pipe dream.
> 
> --Andy
> 

Seconded!

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

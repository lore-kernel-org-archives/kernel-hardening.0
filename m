Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 22 Jan 2016 09:30:50 -0800
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Message-ID: <20160122173050.GE9608@ast-mbp.thefacebook.com>
References: <1453444200-8604-1-git-send-email-daniel.sangorrin@toshiba.co.jp>
 <1453444200-8604-2-git-send-email-daniel.sangorrin@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1453444200-8604-2-git-send-email-daniel.sangorrin@toshiba.co.jp>
Subject: [kernel-hardening] Re: [RFC PATCH 1/1] seccomp: provide information about the previous
 syscall
To: Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
Cc: keescook@chromium.org, luto@amacapital.net, wad@chromium.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 22, 2016 at 03:30:00PM +0900, Daniel Sangorrin wrote:
> This patch allows applications to restrict the order in which
> its system calls may be requested. In order to do that, we
> provide seccomp-BPF scripts with information about the
> previous system call requested.
> 
> An example use case consists of detecting (and stopping) return
> oriented attacks that disturb the normal execution flow of
> a user program.
> 
> Signed-off-by: Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
...
> diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
...
>  struct seccomp_data {
>  	int nr;
> +	int prev_nr;
>  	__u32 arch;
>  	__u64 instruction_pointer;
>  	__u64 args[6];

this will break abi for existing seccomp programs.
New field has to be at the end.

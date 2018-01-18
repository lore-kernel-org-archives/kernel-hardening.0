Date: Thu, 18 Jan 2018 20:33:44 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <20180118203343.GD13338@ZenIV.linux.org.uk>
References: <CA+55aFxsg5+u7bCHj1N8xyyVf7-RMm-5ACNp=ENNrKL78omaow@mail.gmail.com>
 <CAPcyv4hfUx8gLScuNewY3+BWi4YBS_Z9dhvYf1D+WEWDDCShXA@mail.gmail.com>
 <CA+55aFxAFG5czVmCyhYMyHmXLNJ7pcXxWzusjZvLRh_qTGHj6Q@mail.gmail.com>
 <CA+55aFxB01XEEpdPynwYmzQMfTJdJnUrN+ZLqSV_UdnKLBgAZw@mail.gmail.com>
 <1516198646.4184.13.camel@linux.intel.com>
 <20180117185232.GW13338@ZenIV.linux.org.uk>
 <20180118030634.GY13338@ZenIV.linux.org.uk>
 <CA+55aFzKPed+89wz=ajWNpsQ8Kh+AQWx61hwVqqDh7_=h4tecg@mail.gmail.com>
 <20180118044302.GZ13338@ZenIV.linux.org.uk>
 <20180118193156.GC13338@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180118193156.GC13338@ZenIV.linux.org.uk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Subject: [kernel-hardening] Re: [RFC][PATCH] get rid of the use of set_fs() (by way of
 kernel_recvmsg()) in sunrpc
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Network Development <netdev@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 18, 2018 at 07:31:56PM +0000, Al Viro wrote:

> * SO_RCVTIMEO/SO_SNDTIMEO handling in compat [sg]etsockopt()
> * passing SIOC{ADD,DEL}TUNNEL down (ipmr_del_tunnel(),ipmr_new_tunnel(),
>   addrconf_set_dstaddr())
> * SIOCGSTAMP/SIOCGSTAMPNS in compat ioctls
> * SIOCADDRT/SIOCDELRT in compat ioctls
> * kernel_[gs]etsockopt()
> * ipv6_renew_options_kern()
> 
> I don't know if all of that stuff can be realistically done without set_fs().
> kernel_setsockopt(), in particular, is unpleasant...

Speaking of weird indirect calls: in net/packet/af_packet.c:packet_ioctl() we
have this:
#ifdef CONFIG_INET
        case SIOCADDRT:
        case SIOCDELRT:
        case SIOCDARP:
        case SIOCGARP:
        case SIOCSARP:
        case SIOCGIFADDR:
        case SIOCSIFADDR:
        case SIOCGIFBRDADDR:
        case SIOCSIFBRDADDR:
        case SIOCGIFNETMASK:
        case SIOCSIFNETMASK:
        case SIOCGIFDSTADDR:
        case SIOCSIFDSTADDR:
        case SIOCSIFFLAGS:
                return inet_dgram_ops.ioctl(sock, cmd, arg);
#endif

That's inet_ioctl(sock, cmd, arg) disguised by indirect.  AFAICS,
that line dates back to 2.1.89; back then inet_dgram_ops had been
exported and inet_ioctl() had been static.  When SCTP went in
they'd exported inet_ioctl() rather than playing that kind of
games.

Is there anything subtle I'm missing here that would make it
wrong to replace that with explicit call of inet_ioctl()?

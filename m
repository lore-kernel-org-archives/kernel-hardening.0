Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <4DEAD959.5060509@gmail.com>
Date: Sun, 05 Jun 2011 09:18:17 +0800
From: Pavel Labushev <p.labushev@gmail.com>
MIME-Version: 1.0
References: <20110518150601.GA2921@albatros> <20110524023409.GC12486@openwall.com> <20110524151246.GA3401@albatros> <4DE139FE.8050808@gmail.com> <20110604181911.GC5034@openwall.com> <20110604202018.GA8019@shinshilla> <4DEAC96B.1010107@gmail.com>
In-Reply-To: <4DEAC96B.1010107@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] /proc/PID directory hiding
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

>>> Is the above on grsecurity?
>>
>> No, grsecurity hides uid/gid from both *stat*(2) and getdents*(2) functions
>> (implemented as proc_pid_readdir() and pid_getattr()).
> 
> Yes, it's on grsecurity. Just try it and see.
> 
> $ uname -r
> 2.6.39-grsec
> $ find /proc -maxdepth 1 -type d -name 1
> $ ls -ld /proc/1
> dr-xr-x--- 6 root root 0 Jun  4 21:05 /proc/1

Fixed in the latest grsec patches.

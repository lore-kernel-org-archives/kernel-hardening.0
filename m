From: Laura Abbott <labbott@redhat.com>
Message-ID: <a5e688c4-94b8-b0aa-4425-fc687d3aeeca@redhat.com>
Date: Tue, 14 Feb 2017 10:01:27 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Format string gcc-plugin?
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

The recent discussions about %pk led me to start playing around
with writing a gcc plugin (notes about writing a gcc plugin are
forthcoming). My idea was to expand checking of the kernel's additional
formats (%pK, %pR etc.) or possibly even change the format
strings. The big issue is that most of vsprintf.c would end up
in the plugin which would be ugly to maintain. This concept could
be used for some of the problems with kernel pointer leaks
https://kernsec.org/wiki/index.php/Bug_Classes/Kernel_pointer_leak
but I'm interested if anyone else has thoughts or ideas about
how better to do this (or even not to do this).

Thanks,
Laura

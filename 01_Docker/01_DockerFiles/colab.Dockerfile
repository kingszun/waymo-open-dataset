FROM nvidia/cuda:12.2.2-cudnn8-devel-ubuntu22.04


SHELL ["/bin/bash", "-c"]

# Set time zone
RUN ln -snf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

# Set keyboard country
ENV DEBIAN_FRONTEND=noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt update && apt install -y \
  git build-essential wget vim findutils curl \
  pkg-config zip g++ zlib1g-dev unzip

# Set git buffer
RUN git config --global http.postBuffer 524288000
RUN git config --global http.maxRequestBuffer 524288000
RUN git config --global core.compression 0

# Download and compile Python3.10.12
# enable speed optimization of Python binaries
# enable shared libraries
ARG PYTHON3_VERSION_MAIN=3.10 \
PYTHON3_VERSION_PATCH=12


RUN apt install -y openssl apt-transport-https \
make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev liblzma-dev tk-dev

RUN wget https://www.python.org/ftp/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/Python-${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}.tgz \
-O /tmp/Python-${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}.tgz \
&& tar -xzf /tmp/Python-${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}.tgz -C /tmp/
WORKDIR /tmp/Python-${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}

# enable shared libraries: --enable-shared
# enable speed optimization of Python binaries: --enable-optimizations --with-lto --with-computed-gotos --with-system-ffi
RUN ./configure --prefix=/opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/ --enable-optimizations --with-lto --with-computed-gotos --with-system-ffi --enable-shared \
&& make -j $($(nproc)-1) \
&& make altinstall \
&& rm /tmp/Python-${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}.tgz

# ENV LD_LIBRARY_PATH=/opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/lib \
# PATH=${PATH}:/opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin

# update Pip, Setuptools and Wheel packages
RUN /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/python${PYTHON3_VERSION_MAIN} -m pip install --upgrade pip setuptools wheel

RUN apt install -y python3-pip python3-setuptools python3-wheel

RUN python3 -m pip install --upgrade pip \
&& python3 -m pip install --upgrade setuptools \
&& python3 -m pip install --upgrade wheel

# ERROR: No matching distribution found for earthengine-api==0.1.384
# RUN apt install -y python3-setuptools

# No such file or directory: '../../apps/gdal-config'
RUN apt install -y libgdal-dev

# Building wheel for pycairo (pyproject.toml) did not run successfully
RUN apt install -y libcairo2-dev pkg-config python3-dev

# rpy2==3.4.2
RUN apt install -y r-base

# dbus-python
# ERROR: Failed building wheel for dbus-python
RUN apt install -y libdbus-glib-1-dev libdbus-1-dev

# ERROR: Failed building wheel for PyGObject
RUN apt install -y libcairo2-dev

# fatal error: generic.h: No such file or directory
RUN apt install -y python3-dev

# ERROR: Failed building wheel for python-apt
# RUN apt install -y libmysqlclient-dev

# COPY ./01_Docker/02_Requirements/colab_pip_list.txt /tmp/colab_pip_list.txt
# RUN python3 -m pip install -r /tmp/colab_pip_list.txt
RUN python3 -m pip install absl-py==1.4.0 \
&& python3 -m pip install aiohttp==3.9.1 \
&& python3 -m pip install aiosignal==1.3.1 \
&& python3 -m pip install alabaster==0.7.13 \
&& python3 -m pip install albumentations==1.3.1 \
&& python3 -m pip install altair==4.2.2 \
&& python3 -m pip install anyio==3.7.1 \
&& python3 -m pip install appdirs==1.4.4 \
&& python3 -m pip install argon2-cffi==23.1.0 \
&& python3 -m pip install argon2-cffi-bindings==21.2.0 \
&& python3 -m pip install array-record==0.5.0 \
&& python3 -m pip install arviz==0.15.1 \
&& python3 -m pip install astropy==5.3.4 \
&& python3 -m pip install astunparse==1.6.3 \
&& python3 -m pip install async-timeout==4.0.3 \
&& python3 -m pip install atpublic==4.0 \
&& python3 -m pip install attrs==23.1.0 \
&& python3 -m pip install audioread==3.0.1 \
&& python3 -m pip install autograd==1.6.2 \
&& python3 -m pip install Babel==2.14.0 \
&& python3 -m pip install backcall==0.2.0 \
&& python3 -m pip install beautifulsoup4==4.11.2 \
&& python3 -m pip install bidict==0.22.1 \
&& python3 -m pip install bigframes==0.17.0 \
&& python3 -m pip install bleach==6.1.0 \
&& python3 -m pip install blinker==1.4 \
&& python3 -m pip install blis==0.7.11 \
&& python3 -m pip install blosc2==2.0.0 \
&& python3 -m pip install bokeh==3.3.2 \
&& python3 -m pip install bqplot==0.12.42 \
&& python3 -m pip install branca==0.7.0 \
&& python3 -m pip install build==1.0.3 \
&& python3 -m pip install CacheControl==0.13.1 \
&& python3 -m pip install cachetools==5.3.2 \
&& python3 -m pip install catalogue==2.0.10 \
&& python3 -m pip install certifi==2023.11.17 \
&& python3 -m pip install cffi==1.16.0 \
&& python3 -m pip install chardet==5.2.0 \
&& python3 -m pip install charset-normalizer==3.3.2 \
&& python3 -m pip install chex==0.1.7 \
&& python3 -m pip install click==8.1.7 \
&& python3 -m pip install click-plugins==1.1.1 \
&& python3 -m pip install cligj==0.7.2 \
&& python3 -m pip install cloudpickle==2.2.1 \
&& python3 -m pip install cmake==3.27.9 \
&& python3 -m pip install cmdstanpy==1.2.0 \
&& python3 -m pip install colorcet==3.0.1 \
&& python3 -m pip install colorlover==0.3.0 \
&& python3 -m pip install colour==0.1.5 \
&& python3 -m pip install community==1.0.0b1 \
&& python3 -m pip install confection==0.1.4 \
&& python3 -m pip install cons==0.4.6 \
&& python3 -m pip install contextlib2==21.6.0 \
&& python3 -m pip install contourpy==1.2.0 \
&& python3 -m pip install cryptography==41.0.7 \
&& python3 -m pip install cufflinks==0.17.3 \
&& python3 -m pip install cupy-cuda12x==12.2.0 \
&& python3 -m pip install cvxopt==1.3.2 \
&& python3 -m pip install cvxpy==1.3.2 \
&& python3 -m pip install cycler==0.12.1 \
&& python3 -m pip install cymem==2.0.8 \
&& python3 -m pip install Cython==3.0.6 \
&& python3 -m pip install dask==2023.8.1 \
&& python3 -m pip install datascience==0.17.6 \
&& python3 -m pip install db-dtypes==1.2.0 \
&& python3 -m pip install dbus-python==1.2.18 \
&& python3 -m pip install debugpy==1.6.6 \
&& python3 -m pip install decorator==4.4.2 \
&& python3 -m pip install defusedxml==0.7.1 \
&& python3 -m pip install diskcache==5.6.3 \
&& python3 -m pip install distributed==2023.8.1 \
&& python3 -m pip install distro==1.7.0 \
&& python3 -m pip install dlib==19.24.2 \
&& python3 -m pip install dm-tree==0.1.8 \
&& python3 -m pip install docutils==0.18.1 \
&& python3 -m pip install dopamine-rl==4.0.6 \
&& python3 -m pip install duckdb==0.9.2 \
&& python3 -m pip install earthengine-api==0.1.384 \
&& python3 -m pip install easydict==1.11 \
&& python3 -m pip install ecos==2.0.12 \
&& python3 -m pip install editdistance==0.6.2 \
&& python3 -m pip install eerepr==0.0.4 \
&& python3 -m pip install en-core-web-sm==3.6.0 \
&& python3 -m pip install entrypoints==0.4 \
&& python3 -m pip install et-xmlfile==1.1.0 \
&& python3 -m pip install etils==1.6.0 \
&& python3 -m pip install etuples==0.3.9 \
&& python3 -m pip install exceptiongroup==1.2.0 \
&& python3 -m pip install fastai==2.7.13 \
&& python3 -m pip install fastcore==1.5.29 \
&& python3 -m pip install fastdownload==0.0.7 \
&& python3 -m pip install fastjsonschema==2.19.0 \
&& python3 -m pip install fastprogress==1.0.3 \
&& python3 -m pip install fastrlock==0.8.2 \
&& python3 -m pip install filelock==3.13.1 \
&& python3 -m pip install fiona==1.9.5 \
&& python3 -m pip install firebase-admin==5.3.0 \
&& python3 -m pip install Flask==2.2.5 \
&& python3 -m pip install flatbuffers==23.5.26 \
&& python3 -m pip install flax==0.7.5 \
&& python3 -m pip install folium==0.14.0 \
&& python3 -m pip install fonttools==4.46.0 \
&& python3 -m pip install frozendict==2.3.10 \
&& python3 -m pip install frozenlist==1.4.0 \
&& python3 -m pip install fsspec==2023.6.0 \
&& python3 -m pip install future==0.18.3 \
&& python3 -m pip install gast==0.5.4 \
&& python3 -m pip install gcsfs==2023.6.0 \
&& python3 -m pip install GDAL==3.4.3 \
&& python3 -m pip install gdown==4.6.6 \
&& python3 -m pip install geemap==0.29.6 \
&& python3 -m pip install gensim==4.3.2 \
&& python3 -m pip install geocoder==1.38.1 \
&& python3 -m pip install geographiclib==2.0 \
&& python3 -m pip install geopandas==0.13.2 \
&& python3 -m pip install geopy==2.3.0 \
&& python3 -m pip install gin-config==0.5.0 \
&& python3 -m pip install glob2==0.7 \
&& python3 -m pip install google==2.0.3 \
&& python3 -m pip install google-ai-generativelanguage==0.4.0 \
&& python3 -m pip install google-api-core==2.11.1 \
&& python3 -m pip install google-api-python-client==2.84.0 \
&& python3 -m pip install google-auth==2.17.3 \
&& python3 -m pip install google-auth-httplib2==0.1.1 \
&& python3 -m pip install google-auth-oauthlib==1.2.0 \
&& python3 -m pip install google-cloud-aiplatform==1.38.1 \
&& python3 -m pip install google-cloud-bigquery==3.12.0 \
&& python3 -m pip install google-cloud-bigquery-connection==1.12.1 \
&& python3 -m pip install google-cloud-bigquery-storage==2.24.0 \
&& python3 -m pip install google-cloud-core==2.3.3 \
&& python3 -m pip install google-cloud-datastore==2.15.2 \
&& python3 -m pip install google-cloud-firestore==2.11.1 \
&& python3 -m pip install google-cloud-functions==1.13.3 \
&& python3 -m pip install google-cloud-iam==2.13.0 \
&& python3 -m pip install google-cloud-language==2.9.1 \
&& python3 -m pip install google-cloud-resource-manager==1.11.0 \
&& python3 -m pip install google-cloud-storage==2.8.0 \
&& python3 -m pip install google-cloud-translate==3.11.3 \
&& python3 -m pip install google-colab==1.0.0 \
&& python3 -m pip install google-crc32c==1.5.0 \
&& python3 -m pip install google-generativeai==0.3.1 \
&& python3 -m pip install google-pasta==0.2.0 \
&& python3 -m pip install google-resumable-media==2.7.0 \
&& python3 -m pip install googleapis-common-protos==1.62.0 \
&& python3 -m pip install googledrivedownloader==0.4 \
&& python3 -m pip install graphviz==0.20.1 \
&& python3 -m pip install greenlet==3.0.2 \
&& python3 -m pip install grpc-google-iam-v1==0.13.0 \
&& python3 -m pip install grpcio==1.60.0 \
&& python3 -m pip install grpcio-status==1.48.2 \
&& python3 -m pip install gspread==3.4.2 \
&& python3 -m pip install gspread-dataframe==3.3.1 \
&& python3 -m pip install gym==0.25.2 \
&& python3 -m pip install gym-notices==0.0.8 \
&& python3 -m pip install h5netcdf==1.3.0 \
&& python3 -m pip install h5py==3.9.0 \
&& python3 -m pip install holidays==0.38 \
&& python3 -m pip install holoviews==1.17.1 \
&& python3 -m pip install html5lib==1.1 \
&& python3 -m pip install httpimport==1.3.1 \
&& python3 -m pip install httplib2==0.22.0 \
&& python3 -m pip install huggingface-hub==0.19.4 \
&& python3 -m pip install humanize==4.7.0 \
&& python3 -m pip install hyperopt==0.2.7 \
&& python3 -m pip install ibis-framework==6.2.0 \
&& python3 -m pip install idna==3.6 \
&& python3 -m pip install imageio==2.31.6 \
&& python3 -m pip install imageio-ffmpeg==0.4.9 \
&& python3 -m pip install imagesize==1.4.1 \
&& python3 -m pip install imbalanced-learn==0.10.1 \
&& python3 -m pip install imgaug==0.4.0 \
&& python3 -m pip install importlib-metadata==7.0.0 \
&& python3 -m pip install importlib-resources==6.1.1 \
&& python3 -m pip install imutils==0.5.4 \
&& python3 -m pip install inflect==7.0.0 \
&& python3 -m pip install iniconfig==2.0.0 \
&& python3 -m pip install install==1.3.5 \
&& python3 -m pip install intel-openmp==2023.2.3 \
&& python3 -m pip install ipyevents==2.0.2 \
&& python3 -m pip install ipyfilechooser==0.6.0 \
&& python3 -m pip install ipykernel==5.5.6 \
&& python3 -m pip install ipyleaflet==0.18.0 \
&& python3 -m pip install ipython==7.34.0 \
&& python3 -m pip install ipython-genutils==0.2.0 \
&& python3 -m pip install ipython-sql==0.5.0 \
&& python3 -m pip install ipytree==0.2.2 \
&& python3 -m pip install ipywidgets==7.7.1 \
&& python3 -m pip install itsdangerous==2.1.2 \
&& python3 -m pip install jax==0.4.20 \
&& python3 -m pip install jaxlib==0.4.20+cuda12.cudnn89 \
&& python3 -m pip install jeepney==0.7.1 \
&& python3 -m pip install jieba==0.42.1 \
&& python3 -m pip install Jinja2==3.1.2 \
&& python3 -m pip install joblib==1.3.2 \
&& python3 -m pip install jsonpickle==3.0.2 \
&& python3 -m pip install jsonschema==4.19.2 \
&& python3 -m pip install jsonschema-specifications==2023.11.2 \
&& python3 -m pip install jupyter-client==6.1.12 \
&& python3 -m pip install jupyter-console==6.1.0 \
&& python3 -m pip install jupyter_core==5.5.0 \
&& python3 -m pip install jupyter-server==1.24.0 \
&& python3 -m pip install jupyterlab_pygments==0.3.0 \
&& python3 -m pip install jupyterlab-widgets==3.0.9 \
&& python3 -m pip install kaggle==1.5.16 \
&& python3 -m pip install kagglehub==0.1.4 \
&& python3 -m pip install keras==2.15.0 \
&& python3 -m pip install keyring==23.5.0 \
&& python3 -m pip install kiwisolver==1.4.5 \
&& python3 -m pip install langcodes==3.3.0 \
&& python3 -m pip install launchpadlib==1.10.16 \
&& python3 -m pip install lazr.restfulclient==0.14.4 \
&& python3 -m pip install lazr.uri==1.0.6 \
&& python3 -m pip install lazy_loader==0.3 \
&& python3 -m pip install libclang==16.0.6 \
&& python3 -m pip install librosa==0.10.1 \
&& python3 -m pip install lida==0.0.10 \
&& python3 -m pip install lightgbm==4.1.0 \
&& python3 -m pip install linkify-it-py==2.0.2 \
&& python3 -m pip install llmx==0.0.15a0 \
&& python3 -m pip install llvmlite==0.41.1 \
&& python3 -m pip install locket==1.0.0 \
&& python3 -m pip install logical-unification==0.4.6 \
&& python3 -m pip install lxml==4.9.3 \
&& python3 -m pip install malloy==2023.1067 \
&& python3 -m pip install Markdown==3.5.1 \
&& python3 -m pip install markdown-it-py==3.0.0 \
&& python3 -m pip install MarkupSafe==2.1.3 \
&& python3 -m pip install matplotlib==3.7.1 \
&& python3 -m pip install matplotlib-inline==0.1.6 \
&& python3 -m pip install matplotlib-venn==0.11.9 \
&& python3 -m pip install mdit-py-plugins==0.4.0 \
&& python3 -m pip install mdurl==0.1.2 \
&& python3 -m pip install miniKanren==1.0.3 \
&& python3 -m pip install missingno==0.5.2 \
&& python3 -m pip install mistune==0.8.4 \
&& python3 -m pip install mizani==0.9.3 \
&& python3 -m pip install mkl==2023.2.0 \
&& python3 -m pip install ml-dtypes==0.2.0 \
&& python3 -m pip install mlxtend==0.22.0 \
&& python3 -m pip install more-itertools==10.1.0 \
&& python3 -m pip install moviepy==1.0.3 \
&& python3 -m pip install mpmath==1.3.0 \
&& python3 -m pip install msgpack==1.0.7 \
&& python3 -m pip install multidict==6.0.4 \
&& python3 -m pip install multipledispatch==1.0.0 \
&& python3 -m pip install multitasking==0.0.11 \
&& python3 -m pip install murmurhash==1.0.10 \
&& python3 -m pip install music21==9.1.0 \
&& python3 -m pip install natsort==8.4.0 \
&& python3 -m pip install nbclassic==1.0.0 \
&& python3 -m pip install nbclient==0.9.0 \
&& python3 -m pip install nbconvert==6.5.4 \
&& python3 -m pip install nbformat==5.9.2 \
&& python3 -m pip install nest-asyncio==1.5.8 \
&& python3 -m pip install networkx==3.2.1 \
&& python3 -m pip install nibabel==4.0.2 \
&& python3 -m pip install nltk==3.8.1 \
&& python3 -m pip install notebook==6.5.5 \
&& python3 -m pip install notebook_shim==0.2.3 \
&& python3 -m pip install numba==0.58.1 \
&& python3 -m pip install numexpr==2.8.8 \
&& python3 -m pip install numpy==1.23.5 \
&& python3 -m pip install oauth2client==4.1.3 \
&& python3 -m pip install oauthlib==3.2.2 \
&& python3 -m pip install opencv-contrib-python==4.8.0.76 \
&& python3 -m pip install opencv-python==4.8.0.76 \
&& python3 -m pip install opencv-python-headless==4.8.1.78 \
&& python3 -m pip install openpyxl==3.1.2 \
&& python3 -m pip install opt-einsum==3.3.0 \
&& python3 -m pip install optax==0.1.7 \
&& python3 -m pip install orbax-checkpoint==0.4.4 \
&& python3 -m pip install osqp==0.6.2.post8 \
&& python3 -m pip install packaging==23.2 \
&& python3 -m pip install pandas==1.5.3 \
&& python3 -m pip install pandas-datareader==0.10.0 \
&& python3 -m pip install pandas-gbq==0.19.2 \
&& python3 -m pip install pandas-stubs==1.5.3.230304 \
&& python3 -m pip install pandocfilters==1.5.0 \
&& python3 -m pip install panel==1.3.4 \
&& python3 -m pip install param==2.0.1 \
&& python3 -m pip install parso==0.8.3 \
&& python3 -m pip install parsy==2.1 \
&& python3 -m pip install partd==1.4.1 \
&& python3 -m pip install pathlib==1.0.1 \
&& python3 -m pip install pathy==0.10.3 \
&& python3 -m pip install patsy==0.5.4 \
&& python3 -m pip install peewee==3.17.0 \
&& python3 -m pip install pexpect==4.9.0 \
&& python3 -m pip install pickleshare==0.7.5 \
&& python3 -m pip install Pillow==9.4.0 \
&& python3 -m pip install pip==23.1.2 \
&& python3 -m pip install pip-tools==6.13.0 \
&& python3 -m pip install platformdirs==4.1.0 \
&& python3 -m pip install plotly==5.15.0 \
&& python3 -m pip install plotnine==0.12.4 \
&& python3 -m pip install pluggy==1.3.0 \
&& python3 -m pip install polars==0.17.3 \
&& python3 -m pip install pooch==1.8.0 \
&& python3 -m pip install portpicker==1.5.2 \
&& python3 -m pip install prefetch-generator==1.0.3 \
&& python3 -m pip install preshed==3.0.9 \
&& python3 -m pip install prettytable==3.9.0 \
&& python3 -m pip install proglog==0.1.10 \
&& python3 -m pip install progressbar2==4.2.0 \
&& python3 -m pip install prometheus-client==0.19.0 \
&& python3 -m pip install promise==2.3 \
&& python3 -m pip install prompt-toolkit==3.0.43 \
&& python3 -m pip install prophet==1.1.5 \
&& python3 -m pip install proto-plus==1.23.0 \
&& python3 -m pip install protobuf==3.20.3 \
&& python3 -m pip install psutil==5.9.5 \
&& python3 -m pip install psycopg2==2.9.9 \
&& python3 -m pip install ptyprocess==0.7.0 \
&& python3 -m pip install py-cpuinfo==9.0.0 \
&& python3 -m pip install py4j==0.10.9.7 \
&& python3 -m pip install pyarrow==10.0.1 \
&& python3 -m pip install pyasn1==0.5.1 \
&& python3 -m pip install pyasn1-modules==0.3.0 \
&& python3 -m pip install pycocotools==2.0.7 \
&& python3 -m pip install pycparser==2.21 \
&& python3 -m pip install pyct==0.5.0 \
&& python3 -m pip install pydantic==1.10.13 \
&& python3 -m pip install pydata-google-auth==1.8.2 \
&& python3 -m pip install pydot==1.4.2 \
&& python3 -m pip install pydot-ng==2.0.0 \
&& python3 -m pip install pydotplus==2.0.2 \
&& python3 -m pip install PyDrive==1.3.1 \
&& python3 -m pip install PyDrive2==1.6.3 \
&& python3 -m pip install pyerfa==2.0.1.1 \
&& python3 -m pip install pygame==2.5.2 \
&& python3 -m pip install Pygments==2.16.1 \
&& python3 -m pip install PyGObject==3.42.1 \
&& python3 -m pip install PyJWT==2.3.0 \
&& python3 -m pip install pymc==5.7.2 \
&& python3 -m pip install pymystem3==0.2.0 \
&& python3 -m pip install PyOpenGL==3.1.7 \
&& python3 -m pip install pyOpenSSL==23.3.0 \
&& python3 -m pip install pyparsing==3.1.1 \
&& python3 -m pip install pyperclip==1.8.2 \
&& python3 -m pip install pyproj==3.6.1 \
&& python3 -m pip install pyproject_hooks==1.0.0 \
&& python3 -m pip install pyshp==2.3.1 \
&& python3 -m pip install PySocks==1.7.1 \
&& python3 -m pip install pytensor==2.14.2 \
&& python3 -m pip install pytest==7.4.3 \
&& python3 -m pip install python-apt==0.0.0 \
&& python3 -m pip install python-box==7.1.1 \
&& python3 -m pip install python-dateutil==2.8.2 \
&& python3 -m pip install python-louvain==0.16 \
&& python3 -m pip install python-slugify==8.0.1 \
&& python3 -m pip install python-utils==3.8.1 \
&& python3 -m pip install pytz==2023.3.post1 \
&& python3 -m pip install pyviz_comms==3.0.0 \
&& python3 -m pip install PyWavelets==1.5.0 \
&& python3 -m pip install PyYAML==6.0.1 \
&& python3 -m pip install pyzmq==23.2.1 \
&& python3 -m pip install qdldl==0.1.7.post0 \
&& python3 -m pip install qudida==0.0.4 \
&& python3 -m pip install ratelim==0.1.6 \
&& python3 -m pip install referencing==0.32.0 \
&& python3 -m pip install regex==2023.6.3 \
&& python3 -m pip install requests==2.31.0 \
&& python3 -m pip install requests-oauthlib==1.3.1 \
&& python3 -m pip install requirements-parser==0.5.0 \
&& python3 -m pip install rich==13.7.0 \
&& python3 -m pip install rpds-py==0.13.2 \
&& python3 -m pip install rpy2==3.4.2 \
&& python3 -m pip install rsa==4.9 \
&& python3 -m pip install safetensors==0.4.1 \
&& python3 -m pip install scikit-image==0.19.3 \
&& python3 -m pip install scikit-learn==1.2.2 \
&& python3 -m pip install scipy==1.11.4 \
&& python3 -m pip install scooby==0.9.2 \
&& python3 -m pip install scs==3.2.4.post1 \
&& python3 -m pip install seaborn==0.12.2 \
&& python3 -m pip install SecretStorage==3.3.1 \
&& python3 -m pip install Send2Trash==1.8.2 \
&& python3 -m pip install setuptools==67.7.2 \
&& python3 -m pip install shapely==2.0.2 \
&& python3 -m pip install six==1.16.0 \
&& python3 -m pip install sklearn-pandas==2.2.0 \
&& python3 -m pip install smart-open==6.4.0 \
&& python3 -m pip install sniffio==1.3.0 \
&& python3 -m pip install snowballstemmer==2.2.0 \
&& python3 -m pip install sortedcontainers==2.4.0 \
&& python3 -m pip install soundfile==0.12.1 \
&& python3 -m pip install soupsieve==2.5 \
&& python3 -m pip install soxr==0.3.7 \
&& python3 -m pip install spacy==3.6.1 \
&& python3 -m pip install spacy-legacy==3.0.12 \
&& python3 -m pip install spacy-loggers==1.0.5 \
&& python3 -m pip install Sphinx==5.0.2 \
&& python3 -m pip install sphinxcontrib-applehelp==1.0.7 \
&& python3 -m pip install sphinxcontrib-devhelp==1.0.5 \
&& python3 -m pip install sphinxcontrib-htmlhelp==2.0.4 \
&& python3 -m pip install sphinxcontrib-jsmath==1.0.1 \
&& python3 -m pip install sphinxcontrib-qthelp==1.0.6 \
&& python3 -m pip install sphinxcontrib-serializinghtml==1.1.9 \
&& python3 -m pip install SQLAlchemy==2.0.23 \
&& python3 -m pip install sqlglot==17.16.2 \
&& python3 -m pip install sqlparse==0.4.4 \
&& python3 -m pip install srsly==2.4.8 \
&& python3 -m pip install stanio==0.3.0 \
&& python3 -m pip install statsmodels==0.14.1 \
&& python3 -m pip install sympy==1.12 \
&& python3 -m pip install tables==3.8.0 \
&& python3 -m pip install tabulate==0.9.0 \
&& python3 -m pip install tbb==2021.11.0 \
&& python3 -m pip install tblib==3.0.0 \
&& python3 -m pip install tenacity==8.2.3 \
&& python3 -m pip install tensorboard==2.15.1 \
&& python3 -m pip install tensorboard-data-server==0.7.2 \
&& python3 -m pip install tensorflow==2.15.0 \
&& python3 -m pip install tensorflow-datasets==4.9.3 \
&& python3 -m pip install tensorflow-estimator==2.15.0 \
&& python3 -m pip install tensorflow-gcs-config==2.15.0 \
&& python3 -m pip install tensorflow-hub==0.15.0 \
&& python3 -m pip install tensorflow-io-gcs-filesystem==0.34.0 \
&& python3 -m pip install tensorflow-metadata==1.14.0 \
&& python3 -m pip install tensorflow-probability==0.22.0 \
&& python3 -m pip install tensorstore==0.1.45 \
&& python3 -m pip install termcolor==2.4.0 \
&& python3 -m pip install terminado==0.18.0 \
&& python3 -m pip install text-unidecode==1.3 \
&& python3 -m pip install textblob==0.17.1 \
&& python3 -m pip install tf-slim==1.1.0 \
&& python3 -m pip install thinc==8.1.12 \
&& python3 -m pip install threadpoolctl==3.2.0 \
&& python3 -m pip install tifffile==2023.12.9 \
&& python3 -m pip install tinycss2==1.2.1 \
&& python3 -m pip install tokenizers==0.15.0 \
&& python3 -m pip install toml==0.10.2 \
&& python3 -m pip install tomli==2.0.1 \
&& python3 -m pip install toolz==0.12.0 \
&& python3 -m pip install torch==2.1.0+cu121 \
&& python3 -m pip install torchaudio==2.1.0+cu121 \
&& python3 -m pip install torchdata==0.7.0 \
&& python3 -m pip install torchsummary==1.5.1 \
&& python3 -m pip install torchtext==0.16.0 \
&& python3 -m pip install torchvision==0.16.0+cu121 \
&& python3 -m pip install tornado==6.3.2 \
&& python3 -m pip install tqdm==4.66.1 \
&& python3 -m pip install traitlets==5.7.1 \
&& python3 -m pip install traittypes==0.2.1 \
&& python3 -m pip install transformers==4.35.2 \
&& python3 -m pip install triton==2.1.0 \
&& python3 -m pip install tweepy==4.14.0 \
&& python3 -m pip install typer==0.9.0 \
&& python3 -m pip install types-pytz==2023.3.1.1 \
&& python3 -m pip install types-setuptools==69.0.0.0 \
&& python3 -m pip install typing_extensions==4.5.0 \
&& python3 -m pip install tzlocal==5.2 \
&& python3 -m pip install uc-micro-py==1.0.2 \
&& python3 -m pip install uritemplate==4.1.1 \
&& python3 -m pip install urllib3==2.0.7 \
&& python3 -m pip install vega-datasets==0.9.0 \
&& python3 -m pip install wadllib==1.3.6 \
&& python3 -m pip install wasabi==1.1.2 \
&& python3 -m pip install wcwidth==0.2.12 \
&& python3 -m pip install webcolors==1.13 \
&& python3 -m pip install webencodings==0.5.1 \
&& python3 -m pip install websocket-client==1.7.0 \
&& python3 -m pip install Werkzeug==3.0.1 \
&& python3 -m pip install wheel==0.42.0 \
&& python3 -m pip install widgetsnbextension==3.6.6 \
&& python3 -m pip install wordcloud==1.9.3 \
&& python3 -m pip install wrapt==1.14.1 \
&& python3 -m pip install xarray==2023.7.0 \
&& python3 -m pip install xarray-einstats==0.6.0 \
&& python3 -m pip install xgboost==2.0.2 \
&& python3 -m pip install xlrd==2.0.1 \
&& python3 -m pip install xxhash==3.4.1 \
&& python3 -m pip install xyzservices==2023.10.1 \
&& python3 -m pip install yarl==1.9.4 \
&& python3 -m pip install yellowbrick==1.5 \
&& python3 -m pip install yfinance==0.2.33 \
&& python3 -m pip install zict==3.0.0 \
&& python3 -m pip install zipp==3.17.0

# # add some soft links for comfortable usage
# RUN ln -s /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/python${PYTHON3_VERSION_MAIN} /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/python3 \
# && ln -s /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/python${PYTHON3_VERSION_MAIN} /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/python \
# && ln -s /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/pip${PYTHON3_VERSION_MAIN} /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/pip3 \
# && ln -s /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/pip${PYTHON3_VERSION_MAIN} /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/pip \
# && ln -s /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/pydoc${PYTHON3_VERSION_MAIN} /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/pydoc \ 
# && ln -s /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/idle${PYTHON3_VERSION_MAIN} /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/idle \
# && ln -s /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/python${PYTHON3_VERSION_MAIN}-config /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/python-config
# # && cp -rapf /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/* /usr/local/bin \
# # && cp -rapf /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/lib/* /usr/local/lib
